//
//  ResponseBase.swift
//  Hello
//
//  Created by Feng on 2017/8/4.
//
//

import Foundation
import Vapor
import Fluent

let SUCCESS = "请求成功"
let FAILURE = "请求失败"
let STATUS = 1
let RESULTCODE = 1



class ResponseBase {
    var status: Int = 0
    var message: String?
    var data: Node?
    var resultCode: Int = 0
    
    init(status: Int, message: String?, data: Node?, resultCode: Int) {
        self.status = status
        self.data = data
        self.message = message
        self.resultCode = resultCode
    }
}

extension ResponseBase: JSONRepresentable {
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set("status", status)
        try json.set("message", message)
        try json.set("data", data)
        try json.set("resultCode", resultCode)
        return json
    }
}
