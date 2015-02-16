//
//  FirstViewController.swift
//  Tsingshare-iOS
//
//  Created by whn13 on 15/2/13.
//  Copyright (c) 2015年 whn13. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        list()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBOutlet weak var content: UITextField!
    @IBOutlet var messageList: [UITableView]!
    @IBAction func send() {
    }
    
    func list() {
        println("hehe")
    }
}

