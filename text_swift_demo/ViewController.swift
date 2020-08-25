//
//  ViewController.swift
//  text_swift_demo
//
//  Created by Q YiZhong on 2019/7/7.
//  Copyright © 2019 YiZhong Qi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private let colors = [UIColor.blue, UIColor.brown, UIColor.cyan, UIColor.green, UIColor.magenta]

    private var buffer = [DetailViewController]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.edgesForExtendedLayout = .init(rawValue: 0)
        
        self.title = "TFLite测试页面"
        self.setupUI()
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        
    }

    private func setupUI() {
        let vc = CCPageViewController()
        vc.dataSource = self
        self.addChild(vc)
        self.view.addSubview(vc.view)
    }

    private func vc(index: Int) -> UIViewController {
        for vc in buffer where vc.index == index {
            return vc
        }
        let vc = DetailViewController(index: index)
        vc.view.backgroundColor = UIColor.white
        buffer.append(vc)
        return vc
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: CCPageViewControllerDataSource {
    func numbersOfPage() -> Int {
        return 2
    }

    func previewController(formPage index: Int) -> UIViewController {
        return self.vc(index: index)
    }

    func itemText(index: Int) -> String {
        if index == 0 {
            return "NPL"
        } else if index == 1 {
            return "文本分类"
        } else {
            return "???"
        }
    }
}
