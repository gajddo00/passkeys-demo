//
//  JwtResponse.swift
//  PasskeysDemo
//
//  Created by Dominika Gajdová on 06.05.2023.
//

import Foundation

struct JwtResponse: Decodable {
    let accessToken: String
    let tokenType: String
    let refreshToken: String
    let expiresIn: Double
}
