//
//  UserModel.swift
//  Tsingshare-iOS
//
//  Created by whn13 on 15/2/16.
//  Copyright (c) 2015年 whn13. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class UserModel: APIModel {
    var user = NSDictionary()
    var message = ""
    
    func testAlamofire() {
        Alamofire.request(.GET, "http://httpbin.org/get", parameters: ["foo": "bar"])
            .response { (request, response, data, error) in
                println(request)
                println(response)
                println(error)
        }
    }
    
    // unused
    func signin(username: String, password: String) {
        Alamofire.request(.POST, APIUrl+"/auth/signin", parameters: ["username": username, "password": password])
            .responseJSON { (request, response, data, error) in
                if(error == nil && data != nil) {
                    var info = data as NSDictionary
                    //println(info)
                    if var _id = info["_id"] as String? {
                        // signin success
                        //println(_id);
                        self.user = info
                        self.message = ""
                    }
                    else {
                        // signin fail
                        var messageString = info["message"] as String!
                        //println(messageString);
                        self.user = NSDictionary()
                        self.message = messageString
                    }
                }
                else {
                    self.user = NSDictionary()
                    self.message = "network error"
                }
        }
    }
}