//
//  Response.swift
//  Hello
//
//  Created by Feng on 2017/8/3.
//
//

import Foundation
import Fluent
import Vapor

struct ResponseBase1: NodeInitializable {
    var status: Int = 0
    var message: String?
    var data: Any?
    var resultCode: Int = 0
    
    
    init(node: Node) throws {
        status = try node.get("status")
        message = try node.get("message")
        data = try node.get("data")
        resultCode = try node.get("resultCode")
    }
}


