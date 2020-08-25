//
//  TextClassViewController.swift
//  text_swift_demo
//
//  Created by bytedance on 2020/8/6.
//  Copyright © 2020 YiZhong Qi. All rights reserved.
//

import Foundation

import UIKit

class TextClassViewController: UIViewController {

    var index = 0
    var label : UILabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.yellow
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupLabel() {
        let label = UILabel(frame: CGRect(x: 10, y: 50, width: 100, height: 100))
        label.backgroundColor = UIColor.blue
        label.text = "fadsfdsfdsa"
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.numberOfLines = 0
        self.view.addSubview(label)
    }
}
