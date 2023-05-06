//
//  File.swift
//  
//
//  Created by Dominika Gajdová on 06.05.2023.
//

import Fluent
import Vapor

final class RefreshToken: Model, Content {
    static let schema = "refresh_tokens"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "refresh_token")
    var refreshToken: String
    
    @Field(key: "expires_in")
    var expiresIn: Date

    @Parent(key: "user_id")
    var user: User
    
    init() { }
    
    init(id: UUID? = nil, refreshToken: String, expiresIn: Date, userID: User.IDValue) {
        self.id = id
        self.refreshToken = refreshToken
        self.expiresIn = expiresIn
        self.$user.id = userID
    }
}
