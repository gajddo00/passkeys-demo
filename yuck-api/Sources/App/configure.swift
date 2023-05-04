import Fluent
import FluentPostgresDriver
import Vapor
import WebAuthn

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
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
    
    app.webAuthn = WebAuthnManager(
        config: WebAuthnConfig(
            relyingPartyDisplayName: "Yuck API",
            relyingPartyID: "7f2b-93-99-189-152.ngrok-free.app",
            relyingPartyOrigin: "https://7f2b-93-99-189-152.ngrok-free.app"
        )
    )

    // register routes
    try routes(app)
}
