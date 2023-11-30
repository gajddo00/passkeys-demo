//
//  File.swift
//  
//
//  Created by Dominika Gajdová on 06.05.2023.
//

import Vapor

struct RefreshTokenRequest: Content {
    let refreshToken: String
}
