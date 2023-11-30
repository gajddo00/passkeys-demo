//
//  File.swift
//  
//
//  Created by Dominika Gajdová on 06.05.2023.
//

import Foundation
import Vapor
import Fluent
import JWT

protocol JwtServicing {
    func authorize(req: Request, userID: User.IDValue) async throws -> JwtResponse
    func refreshToken(req: Request, userID: User.IDValue) async throws -> JwtResponse
}

final class JwtService: JwtServicing {
    private let accessTokenExpiration: TimeInterval = 10000000 // 2*60
    private let refreshTokenExpiration: TimeInterval = 10000000 // 10*60
    
    func authorize(req: Request, userID: User.IDValue) async throws -> JwtResponse {
        try await createJWTResponse(req: req, userID: userID)
    }
    
    func refreshToken(req: Request, userID: User.IDValue) async throws -> JwtResponse {
        let body = try req.content.decode(RefreshTokenRequest.self)
        
        guard let refreshToken = try await RefreshToken.query(on: req.db)
            .filter(\.$refreshToken == body.refreshToken)
            .filter(\.$user.$id == userID)
            .first()
        else {
            throw Abort(.unauthorized)
        }
        
        guard refreshToken.expiresIn > Date() else {
            throw Abort(.unauthorized)
        }
        
        try await refreshToken.delete(on: req.db)
        return try await createJWTResponse(req: req, userID: userID)
    }
    
    func createJWTResponse(req: Request, userID: User.IDValue) async throws -> JwtResponse {
        let payload = Payload(
            subject: "yuck-api",
            expiration: .init(value: Date().addingTimeInterval(accessTokenExpiration))
        )
        
        let accessToken = try req.jwt.sign(payload)
        let refreshToken = UUID().uuidString
        let expirationDate = Date().addingTimeInterval(accessTokenExpiration).timeIntervalSince1970
        
        /// Save refresh token data.
        try await RefreshToken(
            refreshToken: refreshToken,
            expiresIn: Date().addingTimeInterval(refreshTokenExpiration),
            userID: userID
        ).save(on: req.db)
        
        return JwtResponse(
            accessToken: accessToken,
            tokenType: "Bearer",
            refreshToken: refreshToken,
            expiresIn: expirationDate
        )
    }
}
