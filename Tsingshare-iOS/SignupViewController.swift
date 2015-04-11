//
//  RegisterViewController.swift
//  Tsingshare-iOS
//
//  Created by whn13 on 15/2/13.
//  Copyright (c) 2015年 whn13. All rights reserved.
//

import UIKit
import Alamofire
//import SimpleAlert

class SignupViewController: UIViewController {

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


    @IBOutlet weak var firstname: UITextField!
    @IBOutlet weak var lastname: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var telephone: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBAction func Signup() {
        println("username = \(username.text!) and password = \(password.text!)")
        var param = [
            "firstName": firstname.text!,
            "lastName": lastname.text!,
            "email": email.text!,
            "telephone": telephone.text!,
            "username": username.text!,
            "password": password.text!
        ]
        Alamofire.request(.POST, APIModel().APIUrl+"/auth/signup", parameters: param)
            .responseJSON { (request, response, data, error) in
                if(error == nil && data != nil) {
                    var info = data as! NSDictionary
                    println(info)
                    if var _id = info["_id"] as! String? {
                        // signin success
                        //println(_id);
                        println("signup success")
                        self.performSegueWithIdentifier("signupsuccess", sender: self)
                    }
                    else {
                        // signin fail
                        var messageString = info["message"] as! String!
                        println(messageString);
                        //let alert = SimpleAlert.Controller(title: "Signup Fail", message: messageString, style: .Alert)
                        //alert.addAction(SimpleAlert.Action(title: "OK", style: .OK))
                        //self.presentViewController(alert, animated: true, completion: nil)
                        let alert: UIAlertView = UIAlertView(title: "Signup Fail", message: messageString, delegate: self, cancelButtonTitle: "OK")
                        alert.show()
                    }
                }
                else {
                    println("network error")
                    //let alert = SimpleAlert.Controller(title: "Signup Fail", message: "network error", style: .Alert)
                    //alert.addAction(SimpleAlert.Action(title: "OK", style: .OK))
                    //self.presentViewController(alert, animated: true, completion: nil)
                    let alert: UIAlertView = UIAlertView(title: "Signup Fail", message: "network error", delegate: self, cancelButtonTitle: "OK")
                    alert.show()
                }
        }
    }
    
    // Auto close keyboard when user click other region except the textfield
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        firstname.resignFirstResponder()
        lastname.resignFirstResponder()
        email.resignFirstResponder()
        telephone.resignFirstResponder()
        username.resignFirstResponder()
        password.resignFirstResponder()
    }
    
    weak var activeTextField: UITextField?
    
    //MARK: - Keyboard Management Methods
    
    // Call this method somewhere in your view controller setup code.
    func registerForKeyboardNotifications() {
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self,
            selector: "keyboardWillBeShown:",
            name: UIKeyboardWillShowNotification,
            object: nil)
        notificationCenter.addObserver(self,
            selector: "keyboardWillBeHidden:",
            name: UIKeyboardWillHideNotification,
            object: nil)
    }
    
    // Called when the UIKeyboardDidShowNotification is sent.
    func keyboardWillBeShown(sender: NSNotification) {
        let info: NSDictionary = sender.userInfo!
        let value: NSValue = info.valueForKey(UIKeyboardFrameBeginUserInfoKey) as! NSValue
        let keyboardSize: CGSize = value.CGRectValue().size
        let contentInsets: UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        
        // If active text field is hidden by keyboard, scroll it so it's visible
        // Your app might not need or want this behavior.
        var aRect: CGRect = self.view.frame
        aRect.size.height -= keyboardSize.height
        //let activeTextFieldRect: CGRect? = activeTextField?.frame
        let activeTextFieldRect: CGRect? = username?.frame
        let activeTextFieldOrigin: CGPoint? = activeTextFieldRect?.origin
        if (!CGRectContainsPoint(aRect, activeTextFieldOrigin!)) {
            scrollView.scrollRectToVisible(activeTextFieldRect!, animated:true)
        }
    }
    
    // Called when the UIKeyboardWillHideNotification is sent
    func keyboardWillBeHidden(sender: NSNotification) {
        let contentInsets: UIEdgeInsets = UIEdgeInsetsZero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    //MARK: - UITextField Delegate Methods
    
    func textFieldDidBeginEditing(textField: UITextField!) {
        //activeTextField = textField
        username = textField
        scrollView.scrollEnabled = true
    }
    
    func textFieldDidEndEditing(textField: UITextField!) {
        //activeTextField = nil
        username = nil
        scrollView.scrollEnabled = false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.registerForKeyboardNotifications()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}
