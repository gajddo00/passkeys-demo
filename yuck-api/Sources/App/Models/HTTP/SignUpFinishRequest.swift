//
//  File.swift
//  
//
//  Created by Dominika Gajdová on 04.05.2023.
//

import Foundation
import WebAuthn

struct SignUpFinishRequest: Decodable {
    let challenge: String
    let userId: String
    let credential: RegistrationCredential
}
