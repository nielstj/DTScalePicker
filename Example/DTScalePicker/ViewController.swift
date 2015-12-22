//
//  ViewController.swift
//  DTScalePicker
//
//  Created by Daniel Tjuatja on 12/22/2015.
//  Copyright (c) 2015 Daniel Tjuatja. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func scalePickerValueDidChange(sender : AnyObject) {
        print("VALUE CHANGED")
    }
    

}

