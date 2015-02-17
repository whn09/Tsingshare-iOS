//
//  FirstViewController.swift
//  Tsingshare-iOS
//
//  Created by whn13 on 15/2/13.
//  Copyright (c) 2015年 whn13. All rights reserved.
//

import UIKit
import Alamofire

class MessageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private var dataSource: Dictionary<String, [String]>? //定义表格的数据源
    private var keyArray: [String]?
    private let cellIdef = "zcell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        list()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var base = BaseClass()

    @IBOutlet weak var content: UITextField!
    @IBOutlet var messageList: [UITableView]!
    @IBAction func send() {
    }
    
    func list() {
        
        println(base.cacheGetString("userid"))
        println(base.cacheGetString("displayName"))
        println(base.cacheGetString("username"))
        println(base.cacheGetString("headimg"))
//        Alamofire.request(.GET, APIModel().APIUrl+"/imessages")
//            .responseJSON { (request, response, data, error) in
//                if(error == nil && data != nil) {
//                    var info = data as NSDictionary
//                    println(info)
//                }
//        }
        
        //初始化数据
        demoData()
        
        var frame = self.view.bounds
        frame.origin.y += 20
        frame.size.height -= 20
        
        //初始化表格
        var tableView = UITableView(frame: frame, style: UITableViewStyle.Plain)
        //设置重用标志
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellIdef)
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        //self.view.addSubview(tableView)
    }
    
    private func demoData() {
        dataSource = ["国家": ["中国", "美国", "法国", "德国", "意大利", "英国", "俄罗斯"],
            "种族": ["白种人", "黄种人", "黑种人"], "肤色": ["白种人", "黄种人", "黑种人", "红色"]
        ]
        keyArray = ["国家", "种族", "肤色"]
    }
    
    // MARK: - UITableViewDataSource
    
    //设置表格的组数
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return keyArray!.count
    }
    
    //设置表格每组的行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var array = dataSource![keyArray![section]]
        return array!.count
    }
    
    //设置表格的内容
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdef, forIndexPath: indexPath) as UITableViewCell
        var array = dataSource![keyArray![indexPath.section]]
        cell.textLabel.text = array![indexPath.row]
        return cell
        
    }
    
    //设置每组的标题
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return keyArray![section]
    }
    
    //MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

