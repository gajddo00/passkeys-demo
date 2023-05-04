//
//  File.swift
//  
//
//  Created by Dominika Gajdová on 02.05.2023.
//

import Vapor
import WebAuthn
import Fluent

enum AuthenticationError: LocalizedError {
    case invalidUserId
}

struct AuthController: RouteCollection {
    private let domain = "localhost"
    private let displayName = "Yuck"
    
    func boot(routes: RoutesBuilder) throws {
        let auth = routes.grouped("api", "auth")
        
        auth.post("signup", "begin", use: signUp)
        auth.post("signup", "finish", use: finishSignUp)
    }

    // Two endpoints are necessary to support PassKeys/FIDO.
    // 1. Create options for the credential provider creation with generated challenge.
    func signUp(req: Request) async throws -> PublicKeyCredentialCreationOptions {
        let signInRequest = try req.content.decode(SignInRequest.self)
        
        guard try await User.query(on: req.db)
            .filter(\.$username == signInRequest.username)
            .first() == nil
        else {
            throw Abort(.badRequest, reason: "Username already taken.")
        }
        
        let user = User(username: signInRequest.username)
        try await user.create(on: req.db)
        
        return try req.webAuthn.beginRegistration(user: user, attestation: .none)
    }
    
    // 2. Validate signature and clientDataJSON hash.
    func finishSignUp(req: Request) async throws -> HTTPStatus {
        let request = try req.content.decode(SignUpFinishRequest.self)
        
        guard
            // userId is base64encoded
            let decodedId = request.userId.fromBase64(),
            let userId = UUID(uuidString: decodedId)
        else {
            throw AuthenticationError.invalidUserId
        }
        
        let credential = try await req.webAuthn.finishRegistration(
            challenge: EncodedBase64(request.challenge),
            credentialCreationData: request.credential,
            confirmCredentialIDNotRegisteredYet: { credentialID in
                let existingCredential = try await WebAuthnCredential.query(on: req.db)
                    .filter(\.$id == credentialID)
                    .first()
                return existingCredential == nil
            }
        )
               
        try await WebAuthnCredential(
            from: credential,
            userID: userId
        ).save(on: req.db)
        
        return .ok
    }
}
