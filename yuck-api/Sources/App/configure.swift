import Fluent
import FluentPostgresDriver
import Vapor
import WebAuthn
import JWT

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    DIContainer.registerDependencies(to: app.container)
    
    app.databases.use(.postgres(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? PostgresConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
        password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
        database: Environment.get("DATABASE_NAME") ?? "vapor_database"
    ), as: .psql)

    app.migrations.add(CreateUser())
    app.migrations.add(CreatePost())
    app.migrations.add(CreateWebAuthnCredential())
    app.migrations.add(CreateRefreshToken())
    
    app.webAuthn = WebAuthnManager(
        config: WebAuthnConfig(
            relyingPartyDisplayName: "Yuck API",
            relyingPartyID: "369e-176-102-152-228.ngrok-free.app",
            relyingPartyOrigin: "https://369e-176-102-152-228.ngrok-free.app"
        )
    )
    
    app.jwt.signers.use(.hs256(key: "361115ae-a9b8-4219-93d5-05b8c0ba63be"))

    // register routes
    try routes(app)
}
