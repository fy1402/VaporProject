//
//  User.swift
//  Hello
//
//  Created by Feng on 2017/7/28.
//
//

import Vapor
import Fluent
import MySQLDriver

//public protocol Model: Entity, JSONRepresentable, StringInitializable, ResponseRepresentable {}


struct User: NodeInitializable {
    var id: Node?
    var username: String?
    var pwd: String?
    var nickname: String?
    var create_time: Date?
    var update_time: Date?
    
    init(username: String, pwd: String, nickname: String) {
        self.username = username
        self.pwd = pwd
        self.nickname = nickname;
        self.create_time = Date()
    }
    
    init(node: Node) throws {
        id = try node.get("id")
        username = try node.get("username")
        pwd = try node.get("pwd")
        nickname = try node.get("nickname")
        create_time = try node.get("create_time")
        update_time = try node.get("update_time")
    }
    
    
}

extension User: JSONRepresentable {
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set("id", id)
        try json.set("username", username)
        try json.set("pwd", pwd)
        try json.set("nickname", nickname)
        try json.set("create_time", create_time)
        return json
    }
}

extension User: JSONInitializable {
    init(json: JSON) throws {
        print(json)
//        do {
            try self.init(username: json.get("username"), pwd: json.get("pwd"), nickname: json.get("nickname"))
//        } catch {
//            print(error)
//        }
    }
}

//extension User: Preparation {
    /// Prepares a table/collection in the database
    /// for storing Users
//    static func prepare(_ database: Database) throws {
//        try database.create(self) { builder in
//            builder.id()
//            builder.string("name")
//            builder.int("age")
//        }
//    }
//    
//    /// Undoes what was done in `prepare`
//    static func revert(_ database: Database) throws {
//        try database.delete(self)
//    }
//}
