//
//  Post.swift
//  Yuck
//
//  Created by Dominika Gajdová on 01.05.2023.
//

import Foundation

struct Post {
    let id = UUID()
    let content: String
    let timestamp: Double
    let username: String
    let distanceInKm: Float
    var upVotesCount: Int
    var downVotesCount: Int
    var didUpvote: Bool = false
    var didDownvote: Bool = false
    
    var didVote: Bool {
        didUpvote || didDownvote
    }
    
    mutating func upvote() {
        if !didVote {
            didUpvote = true
            upVotesCount += 1
        }
    }
    
    mutating func downvote() {
        if !didVote {
            didDownvote = true
            downVotesCount -= 1
        }
    }
}

extension Post {
    static let mocks: [Post] = [
        Post(
            content: "Life is a journey, and every step we take leads us on a new path. Embrace the unknown, for it is in the unexpected where we find our true selves.",
            timestamp: 1682947832,
            username: "evzenloveczen",
            distanceInKm: 3.0,
            upVotesCount: 12,
            downVotesCount: 0
        ),
        Post(
            content: "Sometimes, the best thing to do is to let go of what's holding you back and embrace the unknown. Life is full of surprises!",
            timestamp: 1682947884,
            username: "bezednynapoj",
            distanceInKm: 7.2,
            upVotesCount: 1,
            downVotesCount: 0
        ),
        Post(
            content: "Chase your dreams fearlessly.",
            timestamp: 1682947890,
            username: "nekonecnypribeh",
            distanceInKm: 12.0,
            upVotesCount: 3,
            downVotesCount: 10
        )
    ]
}
