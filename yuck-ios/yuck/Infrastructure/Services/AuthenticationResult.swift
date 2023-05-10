//
//  AuthenticationResult.swift
//  Yuck
//
//  Created by Dominika Gajdová on 10.05.2023.
//

enum AuthenticationResult {
    case signIn(JwtResponse)
    case signUp
    case error(AuthenticationError)
}
