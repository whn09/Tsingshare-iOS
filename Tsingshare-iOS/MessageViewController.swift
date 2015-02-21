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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refersh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        refresh(self.refreshControl)
    }
    
    func refresh(Sender: AnyObject)
    {
        Alamofire.request(.GET, APIModel().APIUrl+"/imessages", parameters: ["userid": base.cacheGetString("userid")])
            .responseSwiftyJSON { (request, response, data, error) in
                //println(data)
                if(error == nil && data != nil) {
                    //println(data.count)
                    var tmpArr: [String] = []
                    for var i=0;i<data.count;i++ {
                        //println(i)
                        if let content = data[i]["content"].string{
                            if let created = data[i]["created"].string{
                                //println(content)
                                //println(created)
                                tmpArr.append(content+" created "+created)
                            }
                            else {
                                println(data[i]["created"])
                            }
                        }
                        else {
                            println(data[i]["content"])
                        }
                    }
                    self.dataArr = tmpArr
                    //println(self.dataArr)
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
    }
    
    var dataArr: [String] = []
        
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel.text = self.dataArr[indexPath.row] as String
        
        return cell
    }
    
    // Auto close keyboard when user click other region except the textfield
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
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
        let value: NSValue = info.valueForKey(UIKeyboardFrameBeginUserInfoKey) as NSValue
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

