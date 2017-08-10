//
//  ExampleUser.swift
//  Hello
//
//  Created by Feng on 2017/8/5.
//
//

import Foundation
import Vapor
import Fluent
import FluentProvider
import AuthProvider

final class ExampleUser: Model {

    static let entity = "e_user"
    
    let storage = Storage()
    
    var name: String
    var password: String
    
    
    init(row: Row) throws {
        name = try row.get("name")
        password = try row.get("password")
    }
    
    init(name: String, password: String) {
        self.name = name
        self.password = password
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set("name", name)
        try row.set("password", password)
        return row
    }
    
    
    
}

extension ExampleUser: Preparation {
    
    static func prepare(_ database: Database) throws {
        try database.create(self, closure: { (e_user1) in
            e_user1.id()
            e_user1.string("name")
            e_user1.string("password")
        })
        
        print("ExampleUser __ prepare")
        
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}


extension ExampleUser: JSONInitializable {
    convenience init(json: JSON) throws {
        try self.init(name: json.get("name"),
                      password: json.get("password"))
    }
}

extension ExampleUser: JSONRepresentable {
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set("id", id)
        try json.set("name", name)
        try json.set("password", password)
        return json
    }
}



final class ExampleToken: Model {
    
    static let entity = "e_token"
    
    let storage = Storage()
    
    let token: String
    let example_user_id: Identifier
    
    var user: Parent<ExampleToken, ExampleUser> {
        return parent(id: example_user_id)
    }
    
    init(row: Row) throws {
        token = try row.get("token")
        example_user_id = try row.get("example_user_id")
    }
    
    init(token: String, user: ExampleUser) throws {
        self.token = token
        self.example_user_id = try user.assertExists()
        print("userid-->>> \(self.example_user_id)")
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set("token", token)
        try row.set("example_user_id", example_user_id)
        return row
    }
}

extension ExampleToken: Preparation {
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
    
    static func prepare(_ database: Database) throws {
        try database.create(self, closure: { (e_token) in
            e_token.id()
            e_token.string("token")
            e_token.parent(ExampleUser.self, foreignIdKey: "example_user_id")
        })
    }
}

extension ExampleToken: JSONRepresentable {
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set("token", token)
        try json.set("userId", example_user_id)
        try json.set("id", id)
//        try json.set("create_time", createdAt)
//        try json.set("update_time", updatedAt)
        return json
    }
}

extension ExampleUser: TokenAuthenticatable {
    // the token model that should be queried
    // to authenticate this user
    public typealias TokenType = ExampleToken
}

//extension ExampleToken: Timestampable {
//    static var updatedAtKey: String {
//        return "custom_updated_at"
//    }
//    static var createdAtKey: String { 
//        return "custom_created_at"
//    }
//}



extension Request {
    func user() throws -> ExampleUser {
        return try auth.assertAuthenticated()
    }
}

