//
//  ForgetPasswordViewController.swift
//  Tsingshare-iOS
//
//  Created by whn13 on 15/2/14.
//  Copyright (c) 2015年 whn13. All rights reserved.
//

import UIKit

class ForgetPasswordViewController: UIViewController {

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
    @IBAction func RestorePassword() {
        println("username = \(username.text!)")

    }
    
    // Auto close keyboard when user click other region except the textfield
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        username.resignFirstResponder()
    }
}
