//
//  AuthenticationServicing.swift
//  PasskeysDemo
//
//  Created by Dominika Gajdová on 02.05.2023.
//

import Foundation
import Combine

protocol AuthenticationServicing {
    var authenticationResult: AnyPublisher<AuthenticationResult, Error> { get }
    
    func singUpWith(username: String) async throws -> AuthenticationResult
    func signInWith(username: String) async throws -> AuthenticationResult
    func userExists(username: String) async -> Bool
}
