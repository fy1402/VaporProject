import Vapor
import AuthProvider
import FluentProvider


extension Droplet {
    func setupRoutes() throws {
        get("hello") { req in
            var json = JSON()
            try json.set("hello", "world")
            return json
        }

        get("plaintext") { req in
            return "Hello, world!"
        }

        // response to requests to /info domain
        // with a description of the request
        get("info") { req in
            return req.description
        }

        get("description") { req in
            return req.description
        }
        
//        Throwing
        get("404") { request in
            throw Abort(.notFound)
        }
        
        get("error") { request in
            throw Abort(.badRequest, reason: "Sorry 😱")
        }
        
        try resource("posts", PostController.self)
    }
}

extension Droplet {
    func setupMyRoutes() throws {
        get("hi") { req in
            var json = JSON()
            try json.set("hi", "money")
            return json
        }
        
        // html
        get("html") { request in
            return try self.view.make("index.leaf")
        }
        
        get("index.html") { request in
            return try self.view.make("welcome.html")
        }
        
        
        // template
        get("template") { request in
            return try self.view.make("welcome", [
                "message": "Hello, world!"
                ])
        }
        
        get("users", ":id") { request in
            guard let userId = request.parameters["id"]?.int else {
                throw Abort.badRequest
            }
            
            return "You requested User #\(userId)"
        }
        
    }
    
    func setupControllerRoutes() throws {
        
        
        HelpController().addRoutes(self)
        
//        let tokenMiddleware = TokenAuthenticationMiddleware.init(ExampleUser.self)
//        let authed = self.grouped(tokenMiddleware)
        
//        let passwordMiddleware = PasswordAuthenticationMiddleware(ExampleUser.self)
//        let pwdAuthed = self.grouped(passwordMiddleware)

//        pwdAuthed.get("me1") { req in
//            let au = try req.auth.assertAuthenticated(ExampleUser.self)
//            print(au)
//            return try req.user().name
//        }
        
        let tokenMiddleware = TokenAuthenticationMiddleware(ExampleUser.self)
        let authed = grouped(tokenMiddleware)
        
        
        

        authed.get("me") { req in
            // return the authenticated user's name
            return try req.user().name
        }
        
        authed.group("user1") { (api) in
            UserController().addAuthRoutes(api)
        }
        
        group("user") { (api) in
            UserController().addRoutes(api)
        }
        
        authed.group("/v1") { (api) in
            HelloController().addRoutes(api)
        }
        
//        self.group("/v1") { (api) in
//            HelloController().addRoutes(api)
//        }
        
    }
}
