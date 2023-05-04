//
//  AuthenticationService.swift
//  Yuck
//
//  Created by Dominika Gajdová on 02.05.2023.
//

import Foundation
import AuthenticationServices
import Networking

final class AuthenticationService: NSObject {
    private let domain = Configuration.default.authDomain
    
    private let apiManager: APIManaging
    private var signUpData: SignUpData?
    
    init(apiManager: APIManaging) {
        self.apiManager = apiManager
    }
}

struct SignUpData {
    let challenge: Data
    let userId: String
}

enum AuthenticationError: LocalizedError {
    case invalidChallenge
    case invalidAttestation
}

// MARK: Public
extension AuthenticationService: AuthenticationServicing {
    func singUpWith(username: String) async throws {
        let publicKeyCredentialProvider = ASAuthorizationPlatformPublicKeyCredentialProvider(relyingPartyIdentifier: domain)
        
        // Registration begin request to obtain webAuthn create options.
        let request = SignUpBeginRequest(username: username)
        let response: SignUpBeginResponse = try await apiManager.request(AuthenticationRouter.signUpBegin(request))
        
        guard let challenge = Data(base64Encoded: response.challenge, options: .ignoreUnknownCharacters) else {
            throw AuthenticationError.invalidChallenge
        }
        
        signUpData = .init(challenge: challenge, userId: response.user.id)
        
        let registrationRequest = publicKeyCredentialProvider.createCredentialRegistrationRequest(
            challenge: challenge,
            name: username,
            userID: Data(response.user.id.utf8)
        )
        
        let authController = ASAuthorizationController(authorizationRequests: [registrationRequest])
        authController.delegate = self
        authController.presentationContextProvider = self
        authController.performRequests()
    }
}

// MARK: Private
private extension AuthenticationService {
    func finishSignUp(credential: ASAuthorizationPlatformPublicKeyCredentialRegistration) async throws {
        guard let signUpData else {
            throw AuthenticationError.invalidChallenge
        }
        
        guard let attestation = credential.rawAttestationObject else {
            throw AuthenticationError.invalidAttestation
        }
        
        let request = SignUpFinishRequest(
            challenge: signUpData.challenge.base64EncodedString(),
            userId: signUpData.userId,
            credential: .init(
                id: credential.credentialID.base64EncodedString(),
                rawId: credential.credentialID,
                response: .init(
                    clientDataJSON: credential.rawClientDataJSON,
                    attestationObject: attestation
                )
            )
        )
        
        try await apiManager.request(AuthenticationRouter.signUpFinish(request))
        
        self.signUpData = nil
    }
}

// MARK: Presentation delegate
extension AuthenticationService: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        ASPresentationAnchor()
    }
}

// MARK: Controller delegate
extension AuthenticationService: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        logger.debug("✅ DID COMPLETE AUTHORIZATION: \(authorization.credential)")
        
        switch authorization.credential {
        case let credentialRegistration as ASAuthorizationPlatformPublicKeyCredentialRegistration:
            // Registration result.
            Task {
                do {
                    try await finishSignUp(credential: credentialRegistration)
                } catch {
                    logger.debug(error)
                }
            }
            
        case let credentialAssertion as ASAuthorizationPlatformPublicKeyCredentialAssertion:
            // Signing in result.
            break
            
        case let passwordCredential as ASPasswordCredential:
            break
            
        default:
            logger.debug("Received unknown authorization type.")
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        logger.debug("❌ AUTHORIZATION DID FAIL: \(error)")
    }
}

extension AuthenticationService {
    static let mock = AuthenticationService(apiManager: APIManager())
}
