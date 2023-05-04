//
//  SignUpFinishRequest.swift
//  Yuck
//
//  Created by Dominika Gajdová on 04.05.2023.
//

import Foundation

struct SignUpFinishRequest: Encodable {
    let challenge: String
    let userId: String
    let credential: Credential
    
    struct Credential: Encodable {
        let id: String
        let type: String = "public-key"
        let rawId: Data
        let response: AuthenticatorAttestationResponse
    }
    
    struct AuthenticatorAttestationResponse: Encodable {
        let clientDataJSON: Data
        let attestationObject: Data
    }
}
