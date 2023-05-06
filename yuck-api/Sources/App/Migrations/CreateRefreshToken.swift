//
//  File.swift
//  
//
//  Created by Dominika Gajdová on 06.05.2023.
//

import Fluent

struct CreateRefreshToken: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(RefreshToken.schema)
            .id()
            .field("refresh_token", .string, .required)
            .field("expires_in", .datetime, .required)
            .field("user_id", .uuid, .required, .references(User.schema, "id"))
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema(RefreshToken.schema).delete()
    }
}
