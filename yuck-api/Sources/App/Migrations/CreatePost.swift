//
//  File.swift
//  
//
//  Created by Dominika Gajdová on 02.05.2023.
//

import Vapor
import Fluent

struct CreatePost: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(Post.schema)
            .id()
            .field("content", .string, .required)
            .field("timestamp", .double, .required)
            .field("distance_in_km", .float, .required)
            .field("user_id", .uuid, .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(Post.schema).delete()
    }
}
