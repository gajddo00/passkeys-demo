//
//  SignInFinishRequest.swift
//  PasskeysDemo
//
//  Created by Dominika Gajdová on 06.05.2023.
//

import Foundation

struct SignInFinishRequest: Encodable {
    let challenge: String
    let userId: String
    let credential: Credential
    
    struct Credential: Encodable {
        let id: Data
        let type: String = "public-key"
        let response: AuthenticatorAssertionResponse
        let authenticatorAttachment: String?
    }
    
    struct AuthenticatorAssertionResponse: Encodable {
        let clientDataJSON: Data
        let authenticatorData: Data
        let signature: Data
        let attestationObject: Data?
        let userHandle: String?
    }
}
