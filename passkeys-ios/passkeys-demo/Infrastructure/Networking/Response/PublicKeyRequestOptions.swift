//
//  PublicKeyRequestOptions.swift
//  PasskeysDemo
//
//  Created by Dominika Gajdová on 06.05.2023.
//

import Foundation

struct PublicKeyRequestOptions: Decodable {
    let challenge: String
    let timeout: TimeInterval?
    let rpId: String?
    let allowCredentials: [PublicKeyCredentialDescriptor]?
    
    struct PublicKeyCredentialDescriptor: Decodable {
        let type: String
        let id: String
    }
}
