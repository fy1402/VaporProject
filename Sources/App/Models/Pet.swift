//
//  Pet.swift
//  Hello
//
//  Created by Feng on 2017/8/4.
//
//

import Foundation
import Fluent
import FluentProvider
import MySQLProvider

final class Pet: Model {
    
    static let entity = "pets"
    
    var name: String
    var age: Int
    
//    存储属性允许流利有额外的信息存储在您的模型,模型的数据库id。
    let storage = Storage()
    
//    行结构代表一个数据库行。您的模型应该能够解析和序列化从数据库行。
//    Here's the code for parsing the Pet from the database.
//   这是解析Pet从数据库的代码。
    init(row: Row) throws {
        name = try row.get("name")
        age = try row.get("age")
    }
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
    
//    Here's the code for serializing the Pet to the database.
//    这是序列化的代码Pet到数据库。
    func makeRow() throws -> Row {
        var row = Row()
        try row.set("name", name)
        try row.set("age", age)
        return row
    }
}

//You can do this by conforming your model to Preparation.

extension Pet: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self) { pets in
            pets.id()
            pets.string("name")
            pets.int("age")
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

extension Pet: JSONInitializable {
    convenience init(json: JSON) throws {
        try self.init(name: json.get("name"),
                      age: json.get("age"))
    }
}

extension Pet: JSONRepresentable {
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set("id", id)
        try json.set("name", name)
        try json.set("age", age)
        return json
    }
}

//extension Pet: NodeInitializable {
//    func delete() throws {
//
//    }
//}

//extension Pet: NodeRepresentable {
//
//}
