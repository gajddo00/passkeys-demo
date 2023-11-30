//
//  AuthenticationRouter.swift
//  PasskeysDemo
//
//  Created by Dominika Gajdová on 02.05.2023.
//

import Networking
import Foundation

enum AuthenticationRouter {
    case signUpBegin(username: String)
    case signInBegin(username: String)
    case signUpFinish(SignUpFinishRequest)
    case signInFinish(SignInFinishRequest)
    case usernameCheck(username: String)
}

extension AuthenticationRouter: Requestable {
    var baseURL: URL {
        // swiftlint:disable force_unwrapping
        URL(string: Configuration.default.apiBaseUrl)!
    }
    
    var path: String {
        switch self {
        case .signUpBegin:
            return "/auth/signup/begin"
            
        case .signUpFinish:
            return "/auth/signup/finish"
            
        case .signInBegin:
            return "/auth/signin/begin"
            
        case .signInFinish:
            return "/auth/signin/finish"
            
        case .usernameCheck:
            return "/auth/username/check"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .signUpBegin, .signInBegin, .usernameCheck:
            return .get
            
        case .signUpFinish, .signInFinish:
            return .post
        }
    }
    
    var urlParameters: [String: Any]? {
        switch self {
        case let .signUpBegin(username), let .usernameCheck(username):
            return ["username": username]
            
        case let .signInBegin(username):
            return ["username": username].compactMapValues { $0 }
            
        case .signUpFinish, .signInFinish:
            return nil
        }
    }
    
    var dataType: RequestDataType? {
        switch self {
        case let .signUpFinish(request):
            return .encodable(request)
            
        case let .signInFinish(request):
            return .encodable(request)
            
        case .signUpBegin, .signInBegin, .usernameCheck:
            return nil
        }
    }
    
    var isAuthenticationRequired: Bool {
        switch self {
        case .signUpBegin, .signUpFinish, .signInBegin, .usernameCheck, .signInFinish:
            return false
        }
    }
}
