//
//  DBManager.swift
//  Hello
//
//  Created by Feng on 2017/8/2.
//
//

import Foundation
import MySQL


class DBManager {
    
    private static var instance: DBManager!
    private var databaseConnectionStatus = false
    @discardableResult
    static func share() -> DBManager {
        
        if instance == nil {
            instance = DBManager()
        }
        return instance
    }
    
    private var mysql: MySQL.Database!
    
    init() {
        setUp()
    }
    
    private func setUp() {
        
        do {
            mysql = try Database(hostname: DBConfig.HOST,
                                 user: DBConfig.USER,
                                 password: DBConfig.PWD,
                                 database: DBConfig.DATABASE)
            print("MySQL connect success")
            databaseConnectionStatus = true
        } catch {
            print("MySQL connect failed")
            databaseConnectionStatus = false
        }
    }
    
    func now() -> String {
        // ... Date
        let now              = Date()
        let formatter        = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let created_at       = formatter.string(from:now)
        return created_at
    }
    
    
    @discardableResult
    func userMessage(user_id: String) -> Node {
        guard databaseConnectionStatus else {
            return "数据库连接失败"
        }
        
        do {
            let result = try mysql.makeConnection().execute("select username from Friend where id=\"\(user_id)\";")
            print(result.context)
            return result
        } catch let error {
            print(error)
            return "查无此id"
        }
    }
    
    @discardableResult
    func register(username: String, pwd: String, nickname: String) -> (isOK: Bool, errorInfo: String) {
        guard databaseConnectionStatus else {
            return (false, "数据库连接失败")
        }
        do {
            var results = try mysql.makeConnection().execute("select username from Friend where username=\"\(username)\";")
            if (results.array?.count)! > 0 {
                return (false, "该用户已存在")
            } else {
                print(now())
                results = try mysql.makeConnection().execute("INSERT INTO Friend (username, nickname, pwd, create_time) VALUES (\"\(username)\", \"\(nickname)\", \"\(pwd)\", \"\(now())\");")
                return (true, "")
            }
        } catch {
            print(error)
        }
        return (false , "")
    }
    
    @discardableResult
    func getUserInfo(id: String) -> ResponseBase {
        guard databaseConnectionStatus else {
            return ResponseBase(status: 2, message: FAILURE, data: nil, resultCode: RESULTCODE)
        }
        do {
            let results = try mysql.makeConnection().execute("SELECT * FROM Friend WHERE id=\"\(id)\";")
            if (results.array?.count)! > 0  {
                guard let result = results[0] else {
                    return ResponseBase(status: 2, message: FAILURE, data: nil, resultCode: RESULTCODE)
                }
                return ResponseBase(status: STATUS, message: SUCCESS, data: result, resultCode: RESULTCODE)
            } else {
                return ResponseBase(status: 2, message: FAILURE, data: nil, resultCode: RESULTCODE)
            }
        } catch {
            print(error)
        }
        
        return ResponseBase(status: 2, message: FAILURE, data: nil, resultCode: RESULTCODE)
    }
    
    @discardableResult
    func login(username: String, pwd: String) -> ResponseBase {
        guard databaseConnectionStatus else {
            return ResponseBase(status: 2, message: "数据库连接失败", data: nil, resultCode: 2)
        }
        do {
            let result1 = try mysql.makeConnection().execute("SELECT username FROM Friend WHERE username=\"\(username)\";")
            if (result1.array?.count)! > 0 {
                guard let userName: String = try result1[0]?.get("username") else {
                    return ResponseBase(status: 2, message: "该用户未注册", data: nil, resultCode: 2)
                }
                let result2 = try mysql.makeConnection().execute("SELECT pwd FROM Friend WHERE username=\"\(userName)\";")
                guard let pwdS: String = try result2[0]?.get("pwd") else {
                    return ResponseBase(status: 2, message: FAILURE, data: nil, resultCode: 2)
                }
                if pwd == pwdS {
                    return ResponseBase(status: 1, message: SUCCESS, data: nil, resultCode: 1)
                } else {
                    return ResponseBase(status: 2, message: "密码错误", data: nil, resultCode: 2)
                }
            } else {
                return ResponseBase(status: 2, message: "该用户未注册", data: nil, resultCode: 2)
            }
        } catch {
            print(error)
        }
        return ResponseBase(status: 2, message: FAILURE, data: nil, resultCode: 2)
    }
    
//    @discardableResult
//    func signUpAccount(userName: String, pwd: String) -> (isOK: Bool, erroInfo: String) {
//        
//        guard databaseConnectionStatus else {
//            
//            return (false, "数据库连接失败!")
//        }
//        
//        do {
//            var results = try mysql.makeConnection().execute("select user_id from user where name=\"\(userName)\";")
//            print("\(results)")
//            if results.count > 0 {
            
//                if let userid = results[0]["user_id"] {
            
//                    if case let .number(.int(userid)) = userid {
//                        
//                        print(userid)
//                        return (false, "该用户名已被注册,请换个用户名")
//                    }
//                }
//            } else {
//                
//                results = try mysql.execute("insert into user (name, pwd) values(\"\(userName)\",\"\(pwd)\");")
//                
//                return (true, "")
//            }
//            return (true, "ssssssssssss")
//            
//        } catch let error {
//            
//            print(error)
//        }
//        return (false, "")
//    }
//    func signOutAccount(token: String) -> (isOk: Bool, errorInfo: String) {
//        
//        guard databaseConnectionStatus else {
//            
//            return (false, "数据库连接失败!")
//        }
//        
//        do {
//            var results = try mysql.execute("delete from sign_in where token=\"\(token)\";")
//            results = try mysql.execute("select * from sign_in where token=\"\(token)\";")
//            if results.count == 0 {
//                return (true, "")
//            } else {
//                return (false, "未知错误")
//            }
//        } catch  {
//            
//        }
//        
//        return (false, "未知错误")
//    }
//    func queryUserId(userName: String, pwd: String) -> (userId: Int, erroInfo: String) {
//        
//        guard databaseConnectionStatus else {
//            
//            return (0, "数据库连接失败!")
//        }
//        
//        do {
//            var results = try mysql.execute("select user_id from user where name=\"\(userName)\" and pwd=\"\(pwd)\";")
//            
//            if results.count > 0 {
//                
//                if let userid = results[0]["user_id"] {
//                    
//                    if case let .number(.int(userid)) = userid {
//                        return (userid, "")
//                    }
//                }
//            } else {
//                
//                return (0, "账号或者密码错误!")
//            }
//        } catch  {
//            
//        }
//        return (0, "账号或者密码错误!")
//    }
//    
//    @discardableResult
//    func sigInAccount(userName: String, pwd: String) -> (isOK: Bool, token: String, errorInfo: String) {
//        
//        guard databaseConnectionStatus else {
//            
//            return (false, "", "数据库连接失败!")
//        }
//        let userid = queryUserId(userName: userName, pwd: pwd)
//        
//        if userid.erroInfo != "" {
//            
//            return (false, "", userid.erroInfo)
//        }
//        
//        do {
//            
//            var results = try mysql.execute("select token from sign_in where user_id=\(userid.userId);")
//            
//            if results.count > 0 {
//                
//                if let token = results[0]["token"] {
//                    
//                    if case let .string(token) = token {
//                        return (true, token, "")
//                    }
//                }
//            } else {
//                
//                let token = StringUtility.generateSignInToken(userID: userid.userId)
//                if token == "" {
//                    return (false, "", "获取Token失败!!,请重试!")
//                }
//                let create_time = Date().timeIntervalSince1970
//                
//                results = try mysql.execute("insert into sign_in (user_id, token, create_time) values(\(userid.userId),\"\(token)\",\(create_time));")
//                
//                results = try mysql.execute("select token from sign_in where user_id=\(userid.userId);")
//                
//                if results.count > 0 {
//                    return (true, token, "")
//                } else {
//                    return (false, "", "获取Token失败!!,请重试!")
//                }
//            }
//        } catch {
//            
//        }
//        
//        return (false, "", "获取Token失败!!,请重试!")
//    }
//    
//    @discardableResult
//    func checkTokenExpired(token: String) -> Bool {
//        
//        let expired: Double = 60.0 * 60.0 * 24.0 * 10.0
//        
//        do {
//            print(token)
//            let results = try mysql.execute("select create_time from sign_in where token=\"\(token)\";")
//            print(results)
//            //            if let create_time = results[0]["create_time"] {
//            //
//            //                if case let .number(.double(create_time)) = create_time {
//            //                    print("create_time: \(create_time)")
//            //                    if create_time + expired < Date().timeIntervalSince1970   {
//            //                       return true
//            //                    }
//            //                }
//            //            }
//        } catch {
//            
//        }
//        
//        return false
//    }

    
}
