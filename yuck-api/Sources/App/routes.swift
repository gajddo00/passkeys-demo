import Fluent
import Vapor

func routes(_ app: Application) throws {
    try app.register(collection: AuthController(jwtService: app.container.resolve(type: JwtServicing.self)))
    
    app.get(".well-known", "apple-app-site-association") { req -> Response in
        // let appIdentifier = "com.ollkorrect.yuck"
        let appIdentifier = "EAVQTDVRT7.com.passkey.demo"
        let responseString =
            """
            {
                "applinks": {
                    "details": [
                        {
                            "appIDs": [
                                "\(appIdentifier)"
                            ],
                            "components": [
                            ]
                        }
                    ]
                },
                "webcredentials": {
                    "apps": [
                        "\(appIdentifier)"
                    ]
                }
            }
            """
        let response = try await responseString.encodeResponse(for: req)
        response.headers.contentType = HTTPMediaType(type: "application", subType: "json")
        return response
    }
}
