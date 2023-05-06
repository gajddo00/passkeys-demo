//
//  File.swift
//  
//
//  Created by Dominika Gajdová on 06.05.2023.
//

import Vapor

struct JwtResponse: Content {
    let accessToken: String
    let tokenType: String
    let refreshToken: String
    let expiresIn: Double
}
