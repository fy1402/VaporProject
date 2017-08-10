//
//  HelpController.swift
//  Hello
//
//  Created by Feng on 2017/7/19.
//
//

import Vapor
import HTTP

final class HelpController {
    
    func addRoutes(_ drop: Droplet) {
        drop.get("help", handler: sayHello(_:))
        drop.get("sayhello", String.parameter, handler: sayHelloAlternate(_:))
    }
    
    func sayHello(_ req: Request) throws -> ResponseRepresentable {
        
        print("say hello")
        
        guard let name = req.data["name"]?.string else {
            throw Abort(.badRequest)
        }
        
        return "Hello, \(name)"
    }
    
    func sayHelloAlternate(_ req: Request) -> ResponseRepresentable {
        
        print(req)
        
        do {
            let title = try req.parameters.next(String.self)
            return "Hello, \(title)"
        } catch {
            let title = "error"
            return title
        }
    }

}
