//
//  AuthenticationRouter.swift
//  Yuck
//
//  Created by Dominika Gajdová on 02.05.2023.
//

import Networking
import Foundation

enum AuthenticationRouter {
    case signUpBegin(SignUpBeginRequest)
    case signUpFinish(SignUpFinishRequest)
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
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .signUpBegin, .signUpFinish:
            return .post
        }
    }
    
    var dataType: RequestDataType? {
        switch self {
        case let .signUpBegin(request):
            return .encodable(request)
            
        case let .signUpFinish(request):
            return .encodable(request)
        }
    }
    
    var isAuthenticationRequired: Bool {
        switch self {
        case .signUpBegin, .signUpFinish:
            return false
        }
    }
}
