//
//  WebBrowserViewController.swift
//  Tsingshare-iOS
//
//  Created by whn13 on 15/2/15.
//  Copyright (c) 2015年 whn13. All rights reserved.
//

import UIKit

class WebBrowserViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let url = NSURL(string: "http://wanghenan.com")
        var request = NSURLRequest(URL: url!)
        webView.loadRequest(request)
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

}
