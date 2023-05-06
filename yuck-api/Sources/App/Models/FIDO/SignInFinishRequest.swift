//
//  File.swift
//  
//
//  Created by Dominika Gajdová on 06.05.2023.
//

import Foundation
import WebAuthn

struct SignInFinishRequest: Decodable {
    let challenge: String
    let userId: String
    let credential: AuthenticationCredential
}
