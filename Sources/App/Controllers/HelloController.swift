//
//  HelloController.swift
//  Hello
//
//  Created by Feng on 2017/8/1.
//
//

import Vapor
import HTTP

final class HelloController {
    func addRoutes(_ drop: RouteBuilder) {
        drop.get("foo", "bar", "baz", handler: sayFoo(_ :))
        drop.get("sayHello", handler: sayHello(_:))

        drop.add(.trace, "welcome") { request in
            return "Hello"
        }
        drop.get("friends", handler: friends(_:))
        drop.get("register", handler: register(_:))
        drop.get("login", handler: login(req:))
        drop.get("getUserInfo", handler: getUserInfo(req:))
        
        
        
        /// Pet
        drop.get("addPet", handler: addPet(_:))
        drop.get("findPet", handler: findPet(_:))
        drop.get("deletePet", handler: deletePet(_:))
        drop.get("pet", handler: allPet(_:))
        drop.post("pet1", handler: allPet(_:))
    }
    
    func sayFoo(_ req: Request) throws -> ResponseRepresentable {
        return "You requested /foo/bar/baz"
    }
    
    func sayHello(_ req: Request) throws -> ResponseRepresentable {
        guard let id = req.data["id"]?.string else {
            throw Abort.badRequest
        }
        print("\(id)")
        
        let result = DBManager.share().userMessage(user_id: id)
        
        return try Response(status: .ok, json: JSON(result))
    }
    
    func friends(_ req: Request) throws -> ResponseRepresentable {
//        return try JSON(node: ["friends": [["name": "Sarah", "age": 33],
//                                           ["name": "Steve", "age": 31],
//                                           ["name": "Drew", "age": 35]]
//            ])
        return try Friend.all().makeJSON()
    }
    
    func register(_ req: Request) throws -> ResponseRepresentable {
        guard let name = req.data["username"]?.string else {
            throw Abort.badRequest
        }
        guard let pwd = req.data["pwd"]?.string else {
            throw Abort.badRequest
        }
        var nick = ""
        
        if let nickname = req.data["nickname"]?.string {
            nick = nickname
        } else {
            print("用户无昵称")
        }
        let result = DBManager.share().register(username: name, pwd: pwd, nickname: nick)
        
        
        if result.isOK {
            return try Response(status: .ok, json: JSON("注册成功"))
        } else {
            return try Response(status: .failedDependency, json: JSON(result.errorInfo))
        }
    }
    
    func getUserInfo(req: Request) throws -> ResponseRepresentable {
        guard let id = req.data["id"]?.string else {
            throw Abort.badRequest
        }
        let result = DBManager.share().getUserInfo(id: id)
        return try Response(status: .ok, json: result.makeJSON())
    }
    
    func login(req: Request) throws -> ResponseRepresentable {
        guard let username = req.data["username"]?.string, let pwd = req.data["pwd"]?.string else {
            throw Abort.badRequest
        }
        let result = DBManager.share().login(username: username, pwd: pwd)
        return try Response(status: .ok, json: result.makeJSON())
    }
    
    func addPet(_ req: Request) throws -> ResponseRepresentable {
        for i in 10..<20 {
            let dog = Pet(name: "dog+\(i)", age: i)
            try dog.save()
            print("\(String(describing: dog.id)) + \(dog.name) + \(dog.age)")
        }
        return Response(status: .ok)
    }
    
    func findPet(_ req: Request) throws -> ResponseRepresentable {
        
        guard let id = req.data["id"]?.string else {
            throw Abort.badRequest
        }
        
        guard let dog = try Pet.find(id) else {
            throw Abort.notFound
        }
        
        print(dog.name) // the name of the dog with id 
        return dog.name
    }
    
    func deletePet(_ req: Request) throws -> ResponseRepresentable {
        guard let id = req.data["id"]?.string else {
            throw Abort.badRequest
        }
        
        guard let dog = try Pet.find(id) else {
            throw Abort.notFound
        }
        
        do {
            try dog.delete()
        } catch {
            print(error)
            return error.localizedDescription
        }
        
        return "delete success"
    }
    
    func allPet(_ req: Request) throws -> ResponseRepresentable {
        
        let result = try Pet.all()
        
        return try Response(status: .ok, json: result.makeJSON())
    }
    

}
