//
//  BaseClass.swift
//  Tsingshare-iOS
//
//  Created by whn13 on 15/2/17.
//  Copyright (c) 2015年 whn13. All rights reserved.
//

import Foundation
//工具类,放置一些经常用到的方法
//通过userDefault存储数据
class BaseClass{
    
    func cacheSetString(key: String,value: String){
        var userInfo = NSUserDefaults()
        userInfo.setValue(value, forKey: key)
    }
    
    func cacheGetString(key: String) -> String{
        var userInfo = NSUserDefaults()
        var tmpSign = userInfo.stringForKey(key)
        return tmpSign!
    }
    
}