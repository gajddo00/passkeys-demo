//
//  AuthenticationError.swift
//  PasskeysDemo
//
//  Created by Dominika Gajdová on 06.05.2023.
//

import Foundation

enum AuthenticationError: LocalizedError {
    case invalidChallenge
    case invalidAttestation
    case apiError(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidChallenge, .invalidAttestation:
            return RString.signinErrorUnsuccessful()
            
        case let .apiError(message):
            return "\(RString.signinErrorUnsuccessful()). \(message)"
        }
    }
}
