//
//  Friend.swift
//  Hello
//
//  Created by Feng on 2017/8/2.
//
//

import Foundation
import Vapor
import Fluent
import FluentProvider

final class Friend: Model {
    
    let storage = Storage()
    
    var content: String
    
    /// The column names for `id` and `content` in the database
    static let idKey = "id"
    static let contentKey = "content"
    
    init(content: String) {
        self.content = content
    }
    
    init(row: Row) throws {
        content = try row.get("content")
    }
    
    // Serializes the Post to the database
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Post.contentKey, content)
        return row
    }
}

extension Friend: JSONConvertible {
    convenience init(json: JSON) throws {
        try self.init(
            content: json.get(Post.contentKey)
        )
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Friend.idKey, id)
        try json.set(Friend.contentKey, content)
        return json
    }
}


