//
//  UserController.swift
//  Hello
//
//  Created by Feng on 2017/8/7.
//
//

import Vapor

final class UserController {
    
    func addRoutes(_ api: RouteBuilder) {
        api.get("register", handler: register(_:))
        api.get("login", handler: login(_:))
    }
    
    func addAuthRoutes(_ api: RouteBuilder) {
        api.get("getUserInfo", handler: getUserInfo(_:))
    }
    
    func register(_ req: Request) throws -> ResponseRepresentable {
        guard
            let username = req.data["username"]?.string,
            let password = req.data["password"]?.string
            else {
                throw Abort.badRequest
        }
        
        let users = try ExampleUser.makeQuery().filter("name", username).all()
        
        print(users)
        
        if users.count > 0 {
            return "had user"
        } else {
            let user = ExampleUser(name: username, password: password)
            try user.save()
            return Response(status: .ok)
        }
    }
    
    func login(_ req: Request) throws -> ResponseRepresentable {
        
        guard
            let username = req.data["username"]?.string,
            let password = req.data["password"]?.string
            else {
                throw Abort.badRequest
        }
        
        guard
            let user: ExampleUser = try ExampleUser.makeQuery().filter("name", username).first()
            else {
                throw Abort.badRequest
        }

        
        print(user)
        if password != user.password {
            return "password error"
        }
        
//        guard let userId = user.id else {
//            throw Abort.badRequest
//        }
        
        let auth = try ExampleToken(token: password, user: user)
        do {
            print("\(String(describing: try auth.user.get()))")
            
            print("______________")
            try auth.save()
        } catch {
            print(error)
        }
        
        return try Response(status: .ok, json: auth.makeJSON())
        
//        let user = req.auth.authenticated(ExampleUser.self)
//        print(user?.name)
        
//        let user1 = try req.auth.assertAuthenticated(ExampleUser.self)
//        print(user1.name)
        
        
//        if req.auth.isAuthenticated(ExampleUser.self) {
//            let user = try req.auth.assertAuthenticated(ExampleUser.self)
//            print(user)
//            return user.name
//        } else {
//            return "nil"
//        }
    }
    
    func getUserInfo(_ req: Request) throws -> ResponseRepresentable {
        guard let user: ExampleUser = req.auth.authenticated(ExampleUser.self) else {
            throw Abort.badRequest
        }
        return try Response(status: .ok, json: user.makeJSON())
    }
}
