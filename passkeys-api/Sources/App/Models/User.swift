//
//  File.swift
//  
//
//  Created by Dominika Gajdová on 02.05.2023.
//

import Fluent
import Vapor
import WebAuthn

final class User: Model, Content {
    static let schema = "users"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "username")
    var username: String
    
    @Children(for: \.$user)
    var credentials: [WebAuthnCredential]

    init() { }

    init(id: UUID? = nil, username: String) {
        self.id = id
        self.username = username
    }
}

extension User: WebAuthnUser {
    var userID: String { id!.uuidString }
    var name: String { username }
    var displayName: String { username }
}

extension User: ModelSessionAuthenticatable {}
