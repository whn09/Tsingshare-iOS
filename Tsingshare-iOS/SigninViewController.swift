//
//  LoginViewController.swift
//  Tsingshare-iOS
//
//  Created by whn13 on 15/2/13.
//  Copyright (c) 2015年 whn13. All rights reserved.
//

import UIKit
import Alamofire
import SimpleAlert

class SigninViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBAction func Signin() {
        println("username = \(username.text!) and password = \(password.text!)")
        //var userModel = UserModel()
        //userModel.signin(username.text!, password: password.text!)
        Alamofire.request(.POST, APIModel().APIUrl+"/auth/signin", parameters: ["username": username.text!, "password": password.text!])
            .responseJSON { (request, response, data, error) in
                if(error == nil && data != nil) {
                    var info = data as NSDictionary
                    //println(info)
                    if var _id = info["_id"] as String? {
                        // signin success
                        //println(_id);
                        println("signin success")
                        self.performSegueWithIdentifier("signinsuccess", sender: self)
                    }
                    else {
                        // signin fail
                        var messageString = info["message"] as String!
                        println(messageString);
                        let alert = SimpleAlert.Controller(title: "Signin Fail", message: messageString, style: .Alert)
                        alert.addAction(SimpleAlert.Action(title: "OK", style: .OK))
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                }
                else {
                    println("network error")
                    let alert = SimpleAlert.Controller(title: "Signin Fail", message: "network error", style: .Alert)
                    alert.addAction(SimpleAlert.Action(title: "OK", style: .OK))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
        }

    }
}
