//
//  Created by Dominika Gajdová on 02.05.2023.
//

import Vapor
import WebAuthn
import Fluent
import JWT

enum AuthenticationError: LocalizedError {
    case invalidUserId
}

struct AuthController: RouteCollection {
    private let domain = "369e-176-102-152-228.ngrok-free.app"
    private let displayName = "Yuck"
    
    private let jwtService: JwtServicing
    
    init(jwtService: JwtServicing) {
        self.jwtService = jwtService
    }
    
    func boot(routes: RoutesBuilder) throws {
        let auth = routes.grouped("api", "auth")
        auth.get("username", "check", use: usernameExists)
        auth.get("signup", "begin", use: signUpBegin)
        auth.post("signup", "finish", use: signUpFinish)
        auth.post("signin", "finish", use: signInFinish)
        auth.get("signin", "begin", use: singInBegin)
    }
}

// MARK: Username
extension AuthController {
    func usernameExists(req: Request) async throws -> Bool {
        guard let username = req.query[String.self, at: "username"] else {
            throw Abort(.badRequest, reason: "Missing username.")
        }
        
        guard try await User.query(on: req.db)
            .filter(\.$username == username)
            .first() == nil
        else {
            return true
        }
        
        return false
    }
}

// MARK: Registration
extension AuthController {
    // 1. Create options for the credential provider creation with generated challenge.
    func signUpBegin(req: Request) async throws -> PublicKeyCredentialCreationOptions {
        guard let username = req.query[String.self, at: "username"] else {
            throw Abort(.badRequest, reason: "Missing username.")
        }
        
        guard try await User.query(on: req.db)
            .filter(\.$username == username)
            .first() == nil
        else {
            throw Abort(.badRequest, reason: "Username already taken.")
        }
        
        let user = User(id: UUID(), username: username)
        return try req.webAuthn.beginRegistration(user: user, attestation: .none)
    }
    
    // 2. Validate signature and clientDataJSON hash.
    func signUpFinish(req: Request) async throws -> HTTPStatus {
        let request = try req.content.decode(SignUpFinishRequest.self)
        
        guard
            // userId is base64encoded
            let decodedId = request.userId.fromBase64(),
            let userId = UUID(uuidString: decodedId)
        else {
            throw AuthenticationError.invalidUserId
        }
        
        // Verify and get the final fido credential that will be associated with the account.
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
        
        // Save user and their fido credential to database.
        try await User(id: userId, username: request.username)
            .save(on: req.db)
               
        try await WebAuthnCredential(
            from: credential,
            userID: userId
        ).save(on: req.db)
        
        return .ok
    }
}

// MARK: Authentication
extension AuthController {
    func singInBegin(req: Request) async throws -> PublicKeyCredentialRequestOptions {
        // if the user specified a username, we'll fetch a list of saved credentials for that user
        var allowCredentials: [PublicKeyCredentialDescriptor]?
        if let username = req.query[String.self, at: "username"] {
            guard let user = try await User.query(on: req.db).filter(\.$username == username).first() else {
                throw Abort(.badRequest, reason: "User does not exist")
            }

            let credentials = try await user.$credentials.get(on: req.db)
            // User can have multiple credentials for one app,
            // so let's only allow those that actually match the username.
            allowCredentials = credentials.map {
                let idData = [UInt8](URLEncodedBase64($0.id!).urlDecoded.decoded!)
                return PublicKeyCredentialDescriptor(type: "public-key", id: idData)
            }
            
            guard allowCredentials!.count > 0 else {
                throw Abort(.badRequest, reason: "User has no registered credentials")
            }
        }

        return try req.webAuthn.beginAuthentication(allowCredentials: allowCredentials)        
    }
    
    func signInFinish(req: Request) async throws -> JwtResponse {
        let request = try req.content.decode(SignInFinishRequest.self)
        
        // find the credential the stranger claims to possess
        guard let credential = try await WebAuthnCredential.query(on: req.db)
            .filter(\.$id == request.credential.id.asString())
            .with(\.$user)
            .first() else {
            throw Abort(.unauthorized)
        }
        
        // if we found a credential, use the stored public key to verify the challenge
        let verifiedAuthentication = try req.webAuthn.finishAuthentication(
            credential: request.credential,
            expectedChallenge: EncodedBase64(request.challenge).urlEncoded,
            credentialPublicKey: [UInt8](URLEncodedBase64(credential.publicKey).urlDecoded.decoded!),
            credentialCurrentSignCount: UInt32(credential.currentSignCount)
        )
        
        // if we successfully verified the user, update the sign count
        credential.currentSignCount = Int32(verifiedAuthentication.newSignCount)
        try await credential.save(on: req.db)
        
        return try await jwtService.authorize(req: req, userID: credential.user.id!)
    }
}
