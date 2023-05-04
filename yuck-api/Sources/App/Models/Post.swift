//
//  File.swift
//  
//
//  Created by Dominika Gajdová on 02.05.2023.
//

import Fluent
import Vapor

final class Post: Model, Content {
    static let schema = "posts"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "content")
    var content: String
    
    @Field(key: "timestamp")
    var timestamp: Double
    
    @Field(key: "distance_in_km")
    var distanceInKm: Float

    @Field(key: "user_id")
    var userId: UUID

    init() { }

    init(id: UUID? = nil, content: String, timestamp: Double, distanceInKm: Float, userId: UUID) {
        self.id = id
        self.content = content
        self.timestamp = timestamp
        self.distanceInKm = distanceInKm
        self.userId = userId
    }
}
