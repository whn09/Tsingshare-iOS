//
//  FirstViewController.swift
//  Tsingshare-iOS
//
//  Created by whn13 on 15/2/13.
//  Copyright (c) 2015年 whn13. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MessageViewController: UIViewController {
    
    var refreshControl:UIRefreshControl!  // An optional variable
    var currentPage = 1
    var totalPage = 1
    var pageSize = 10
    var endPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refersh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        Alamofire.request(.GET, APIModel().APIUrl+"/imessages/count", parameters: ["userid": base.cacheGetString("userid")])
            .responseJSON { (request, response, data, error) in
                //println(data)
                if(error == nil && data != nil) {
                    var data = JSON(data!)
                    if let totalCount = data.int{
                        if(totalCount % self.pageSize == 0) {
                            self.totalPage = totalCount / self.pageSize
                        }
                        else {
                            self.totalPage = totalCount / self.pageSize + 1
                        }
                        self.currentPage = self.totalPage
                        self.endPage = self.totalPage
                        self.refresh(self.refreshControl)
                    }
                }
        }
    }
    
    func refresh(Sender: AnyObject)
    {
        println("refresh")
        println(self.currentPage)
        if(self.currentPage == 0) {
            self.refreshControl.endRefreshing()
            return
        }
        Alamofire.request(.GET, APIModel().APIUrl+"/imessages", parameters: ["userid": base.cacheGetString("userid"), "page": self.currentPage, "pagesize": self.pageSize])
            .responseJSON { (request, response, data, error) in
                //println(self.base.cacheGetString("userid"))
                //println(data)
                if(error == nil && data != nil) {
                    //println(data.count)
                    var data = JSON(data!)
                    var tmpArr: [String] = []
                    for var i=0;i<data.count;i++ {
                        //println(i)
                        if let content = data[i]["content"].string{
                            //println(content)
                            //println(created)
                            tmpArr.append(content)
                        }
                    }
                    self.dataArr = tmpArr+self.dataArr
                    //println(self.dataArr)
                    if (self.currentPage >= 1) {
                        self.currentPage--;
                    }
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var base = BaseClass()

    @IBOutlet weak var content: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func send() {
        //println("content = \(content.text!)")
        if(content.text! == "") {
            return
        }
        Alamofire.request(.POST, APIModel().APIUrl+"/imessages", parameters: ["content": content.text!, "userid": base.cacheGetString("userid"), "touserid": base.cacheGetString("loverid")])
            .responseJSON { (request, response, data, error) in
                if(error == nil && data != nil) {
                    var info = data as! NSDictionary
                    println(info)
                    if var _id = info["_id"] as! String? {
                        // signin success
                        //println(_id);
                        if var content = info["content"] as! String? {
                            self.content.text = nil
                            self.dataArr.append(content)
                            self.tableView.reloadData()
                            if(self.dataArr.count >= self.pageSize) {
                                self.tableView.setContentOffset(CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height), animated: true) // 跳转到列表最下方
                            }
                        }
                        //println("send success")
                    }
                    else {
                        // signin fail
                        var messageString = info["message"] as! String!
                        println(messageString);
                        //let alert = SimpleAlert.Controller(title: "Signin Fail", message: messageString, style: .Alert)
                        //alert.addAction(SimpleAlert.Action(title: "OK", style: .OK))
                        //self.presentViewController(alert, animated: true, completion: nil)
                        let alert: UIAlertView = UIAlertView(title: "Send Fail", message: messageString, delegate: self, cancelButtonTitle: "OK")
                        alert.show()
                    }
                }
                else {
                    println("network error")
                    //let alert = SimpleAlert.Controller(title: "Signin Fail", message: "network error", style: .Alert)
                    //alert.addAction(SimpleAlert.Action(title: "OK", style: .OK))
                    //self.presentViewController(alert, animated: true, completion: nil)
                    let alert: UIAlertView = UIAlertView(title: "Send Fail", message: "network error", delegate: self, cancelButtonTitle: "OK")
                    alert.show()
                }
        }
    }
    
    var dataArr: [String] = []
        
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        
        cell.textLabel?.text = self.dataArr[indexPath.row] as String
        
        return cell
    }
    
    // Auto close keyboard when user click other region except the textfield
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        content.resignFirstResponder()
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
        let activeTextFieldRect: CGRect? = content?.frame
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
        content = textField
        scrollView.scrollEnabled = true
    }
    
    func textFieldDidEndEditing(textField: UITextField!) {
        //activeTextField = nil
        content = nil
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

