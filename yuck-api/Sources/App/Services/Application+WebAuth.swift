//
//  File.swift
//  
//
//  Created by Dominika Gajdová on 02.05.2023.
//

import Vapor
import WebAuthn

extension Application {
    struct WebAuthnKey: StorageKey {
        typealias Value = WebAuthnManager
    }

    var webAuthn: WebAuthnManager {
        get {
            guard let webAuthn = storage[WebAuthnKey.self] else {
                fatalError("WebAuthn is not configured. Use app.webAuthn = ...")
            }
            return webAuthn
        }
        set {
            storage[WebAuthnKey.self] = newValue
        }
    }
}

extension Request {
    var webAuthn: WebAuthnManager { application.webAuthn }
}

extension RegistrationCredential: Content {}
extension AuthenticationCredential: Content {}
extension PublicKeyCredentialCreationOptions: Content {}
extension PublicKeyCredentialRequestOptions: Content {}
