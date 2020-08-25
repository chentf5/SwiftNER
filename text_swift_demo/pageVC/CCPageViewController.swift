//
//  CCPageViewController.swift
//  CCPageViewController
//
//  Created by cyd on 2018/3/23.
//  Copyright © 2018年 cyd. All rights reserved.
//

import UIKit

@objc protocol CCPageViewControllerDataSource: NSObjectProtocol {
    /// 标题
    @objc optional
    func itemText(index: Int) -> String

    /// 一共有多少页
    func numbersOfPage() -> Int

    /// 每页对应的VC
    func previewController(formPage index: Int) -> UIViewController
}

class CCPageViewController: UIViewController {

    weak var dataSource: CCPageViewControllerDataSource?

    /// 标题字体
    var headerFont = UIFont.boldSystemFont(ofSize: 18)
    /// 标题颜色
    var headerColor = UIColor.init(red: 51/255, green: 113/255, blue: 255/255, alpha: 0.5)
    /// 标题选中颜色
    var headerHigColor = UIColor.white
    
    var MainStyleColor = UIColor.init(red: 51/255, green: 113/255, blue: 255/255, alpha: 1)
    var tip = UIView()
    /// 当前页码
    var currentPage: Int {
        return self.index
    }

    // 标题高度(<=0时，则没有标题)
    private var headerHeight: CGFloat = 60.0
    private var startingIndex: Int = 0
    private var style: UIPageViewController.TransitionStyle = .scroll
    private var index: Int = 0
    private var number: Int = 0
    private var buttons: [UIButton] = [UIButton]()

    private lazy var pageController: UIPageViewController = {
        let op = [UIPageViewController.OptionsKey.spineLocation: UIPageViewController.SpineLocation.min]
        let vc = UIPageViewController(transitionStyle: style, navigationOrientation: .horizontal, options: op)
        vc.view.backgroundColor = UIColor.white
        vc.dataSource = self
        vc.delegate = self
        return vc
    }()

    private lazy var headerView: UIScrollView = {
        let view = UIScrollView()
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: headerHeight)
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = MainStyleColor
        return view
    }()

    init(start: Int = 0, headerHeight: CGFloat = 55.0, style: UIPageViewController.TransitionStyle = .scroll) {
        super.init(nibName: nil, bundle: nil)
        self.style = style
        self.index = start
        self.headerHeight = headerHeight
        self.startingIndex = start
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.number = self.dataSource?.numbersOfPage() ?? 0
        self.setupUI()
    }

    private func setupUI() {
        self.addChild(pageController)
        self.view.addSubview(pageController.view)

        // 标题
        if headerHeight > 0 {
            self.view.addSubview(headerView)
            self.pageController.view.frame.origin.y += headerHeight
            self.pageController.view.frame.size.height -= headerHeight

            self.setupHeaderItems(number: number)
            self.selected(buttons.first ?? UIButton(type: .custom))
        }

        // 初始界面
        guard let start = self.dataSource?.previewController(formPage: index) else {
            return
        }
        self.pageController.setViewControllers([start], direction: .forward, animated: false, completion: nil)
    }

    private func setupHeaderItems(number: Int) {
        let w1 = UIScreen.main.bounds.width / CGFloat(number)
        for i in 0..<number {
            let text = (self.dataSource?.itemText?(index: i) ?? "") as NSString
            let w2 = text.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: headerFont.lineHeight),
                                       options: .usesLineFragmentOrigin,
                                       attributes: [NSAttributedString.Key.font: headerFont],
                                       context: nil).width + 10
            let button = UIButton(type: .custom)
            button.frame = CGRect(x: buttons.last?.frame.maxX ?? 0, y: 0, width: max(w1, w2), height: headerHeight - 5)
            button.setTitle(text as String, for: .normal)
            button.titleLabel?.font = headerFont

            button.setTitleColor(headerHigColor, for: .normal)
            button.setTitleColor(headerHigColor, for: .selected)
            button.setTitleColor(headerHigColor, for: UIControl.State(rawValue: UIControl.State.highlighted.rawValue | UIControl.State.selected.rawValue))
            button.addTarget(self, action: #selector(buttonClick(_:)), for: .touchUpInside)
            
            headerView.addSubview(button)
            headerView.contentSize = CGSize(width: button.frame.maxX, height: headerHeight)
            
            buttons.append(button)
        }
    }

    @objc private func buttonClick(_ button: UIButton) {
        self.selected(button)
        let index = buttons.index(of: button) ?? 0
        let vc = self.dataSource!.previewController(formPage: index)
        pageController.setViewControllers([vc], direction: index > self.index ? .forward : .reverse, animated: true) { _ in
            self.index = index
        }
    }

    private func selected(_ button: UIButton) {
        for btn in buttons where btn.isSelected == true {
            btn.isSelected = false
        }
        button.isSelected = true
        let minX = CGFloat(0.0)
        let maxX = headerView.contentSize.width - UIScreen.main.bounds.width
        let x = min(max(button.frame.midX - UIScreen.main.bounds.width/2, minX), maxX)
        tip.frame = CGRect(x: button.frame.origin.x, y: headerHeight-5, width: UIScreen.main.bounds.width/2, height: 3)
        tip.backgroundColor = UIColor.white
        headerView.addSubview(tip)
        headerView.setContentOffset(CGPoint(x: x, y: 0.0), animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension CCPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = (viewController as? DetailViewController)?.index else {
            return nil
        }
        if index == 0 {
            return nil
        }
        return self.dataSource?.previewController(formPage: index - 1)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = (viewController as? DetailViewController)?.index else {
            return nil
        }
        if index == number - 1 {
            return nil
        }
        return self.dataSource?.previewController(formPage: index + 1)
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        self.index = (pageViewController.viewControllers?.first as? DetailViewController)?.index ?? 0
        if index < buttons.count {
            self.selected(buttons[index])
        }
    }
}
