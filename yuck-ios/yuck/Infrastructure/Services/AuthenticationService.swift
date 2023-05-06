//
//  AuthenticationService.swift
//  Yuck
//
//  Created by Dominika Gajdová on 02.05.2023.
//

import Foundation
import AuthenticationServices
import Networking
import Combine

final class AuthenticationService: NSObject {
    private let domain = Configuration.default.authDomain
    
    private let apiManager: APIManaging
    private var signUpData: SignUpData?
    
    private let resultSubject = PassthroughSubject<AuthenticationResult, Error>()
    
    init(apiManager: APIManaging) {
        self.apiManager = apiManager
    }
}

// MARK: Public
extension AuthenticationService: AuthenticationServicing {
    var authenticationResult: AnyPublisher<AuthenticationResult, Error> {
        resultSubject.eraseToAnyPublisher()
    }
    
    func userExists(username: String) async -> Bool {
        do {
            let response: Bool = try await apiManager.request(AuthenticationRouter.usernameCheck(username: username))
            return response
        } catch {
            return false
        }
    }
    
    func singUpWith(username: String) async throws -> AuthenticationResult {
        let publicKeyCredentialProvider = ASAuthorizationPlatformPublicKeyCredentialProvider(relyingPartyIdentifier: domain)
        
        // Registration begin request to obtain webAuthn create options.
        let response: PublicKeyCredentialOptions = try await apiManager.request(
            AuthenticationRouter.signUpBegin(username: username)
        )
        
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
        
        return try await resultSubject.async()
    }
    
    func signInWith(username: String) async throws -> AuthenticationResult {
        let publicKeyCredentialProvider = ASAuthorizationPlatformPublicKeyCredentialProvider(relyingPartyIdentifier: domain)

        let response: PublicKeyRequestOptions = try await apiManager.request(
            AuthenticationRouter.signInBegin(username: username)
        )
        
        guard let challenge = Data(base64Encoded: response.challenge, options: .ignoreUnknownCharacters) else {
            throw AuthenticationError.invalidChallenge
        }
        
        signUpData = .init(challenge: challenge, userId: "")
        
        let assertionRequest = publicKeyCredentialProvider.createCredentialAssertionRequest(challenge: challenge)
        assertionRequest.allowedCredentials = response.allowCredentials?
            .compactMap { $0.id.fromBase64() }
            .map { ASAuthorizationPlatformPublicKeyCredentialDescriptor(credentialID: $0) } ?? []
        
        let authController = ASAuthorizationController(authorizationRequests: [assertionRequest])
        authController.delegate = self
        authController.presentationContextProvider = self
        authController.performRequests()
        
        return try await resultSubject.async()
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
        
        self.signUpData = nil
        try await apiManager.request(AuthenticationRouter.signUpFinish(request))
        
        resultSubject.send(.signUp)
    }
    
    func finishSignIn(assertion: ASAuthorizationPlatformPublicKeyCredentialAssertion) async throws {
        guard let signUpData else {
            throw AuthenticationError.invalidChallenge
        }
        
        let request = SignInFinishRequest(
            challenge: signUpData.challenge.base64EncodedString(),
            userId: assertion.userID.base64EncodedString(),
            credential: .init(
                id: assertion.credentialID,
                response: .init(
                    clientDataJSON: assertion.rawClientDataJSON,
                    authenticatorData: assertion.rawAuthenticatorData,
                    signature: assertion.signature,
                    attestationObject: nil,
                    userHandle: nil
                ),
                authenticatorAttachment: nil
            )
        )
        
        self.signUpData = nil
        
        let response: JwtResponse = try await apiManager.request(AuthenticationRouter.signInFinish(request))
        resultSubject.send(.signIn(response))
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
                    resultSubject.send(.error(error))
                }
            }
            
        case let credentialAssertion as ASAuthorizationPlatformPublicKeyCredentialAssertion:
            // Authentication result.
            Task {
                do {
                    try await finishSignIn(assertion: credentialAssertion)
                } catch {
                    logger.debug(error)
                }
            }
            
        case _ as ASPasswordCredential:
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
