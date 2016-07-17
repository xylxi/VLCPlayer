//
//  ViewController.swift
//  VLCPlayer
//
//  Created by yuanmaochao on 16/7/16.
//  Copyright © 2016年 king. All rights reserved.
//

import UIKit

class ViewController: UIViewController {


    @IBOutlet weak var networkPath: UITextField!
    @IBOutlet weak var localPath: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func palyNetWork(sender: UIButton) {
        
        view.endEditing(true)
        if let urlStr = networkPath.text{
            if let url = NSURL(string: urlStr) {
                let vc = PlayViewController(url: url)
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    @IBAction func palyLocal(sender: UIButton) {
        
        view.endEditing(true)
        if let name = localPath.text {
            if let path = NSBundle.mainBundle().pathForResource(name, ofType: nil) {
                let vc = PlayViewController(filePath: path)
                presentViewController(vc, animated: true, completion: nil)
            }
        }
        
    }
    
}

