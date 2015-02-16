//
//  UserModel.swift
//  Tsingshare-iOS
//
//  Created by whn13 on 15/2/16.
//  Copyright (c) 2015年 whn13. All rights reserved.
//

import Foundation
import Alamofire

class UserModel: APIModel {
    func testAlamofire() {
        Alamofire.request(.GET, "http://httpbin.org/get", parameters: ["foo": "bar"])
            .response { (request, response, data, error) in
                println(request)
                println(response)
                println(error)
        }
    }
    
    func signin(username: String, password: String) {
        Alamofire.request(.POST, APIUrl+"/auth/signin", parameters: ["username": username, "password": password])
            .response { (request, response, data, error) in
                println(request)
                println(response)
                println(error)
        }
    }
}