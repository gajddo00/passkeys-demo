//
//  SignUpBeginResponse.swift
//  PasskeysDemo
//
//  Created by Dominika Gajdová on 02.05.2023.
//

import Foundation

// swiftlint:disable identifier_name
struct PublicKeyCredentialOptions: Codable {
    let rp: Rp
    let timeout: Int
    let attestation: String
    let pubKeyCredParams: [PubKeyCredParam]
    let challenge: String
    let user: User
    
    // MARK: - PubKeyCredParam
    struct PubKeyCredParam: Codable {
        let type: String
        let alg: Int
    }

    // MARK: - Rp
    // swiftlint:disable type_name
    struct Rp: Codable {
        let name, id: String
    }

    // MARK: - User
    struct User: Codable {
        let name, id, displayName: String
    }
}
