//
//  ProfileViewController.swift
//  Tsingshare-iOS
//
//  Created by whn13 on 15/2/17.
//  Copyright (c) 2015年 whn13. All rights reserved.
//

import UIKit
import Alamofire
import Foundation

class ProfileViewController: UIViewController, UITableViewDelegate {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        Alamofire.request(.GET, APIModel().APIUrl+"/users/me", parameters: ["userid": base.cacheGetString("userid")])
            .responseJSON { (request, response, data, error) in
                //println(data)
                if(error == nil && data != nil) {
                    var info = data as NSDictionary
                    //println(info)
                    var cnt = 0
                    for item in self.dataArr {
                        var value = info.objectForKey(item) as String
                        self.dataArr[cnt] = item+":"+value
                        cnt++
                    }
                    //println(self.dataArr)
                    self.tableView.reloadData()
                }
        }
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
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

    @IBOutlet weak var tableView: UITableView!
    
    var dataArr: [String] = ["firstName", "lastName", "username", "email", "telephone", "gender", "birthday", "headimg"]
    
    var base = BaseClass()
    
    func list() {
    //初始化数据
    //demoData()
        println(base.cacheGetString("username"))
        
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel.text = self.dataArr[indexPath.row] as String
        
        return cell
    }
}