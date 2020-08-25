//
//  DetailViewController.swift
//  CCPageViewController
//
//  Created by cyd on 2018/3/23.
//  Copyright © 2018年 cyd. All rights reserved.
//

import UIKit
import Alamofire

class textClassif : NSObject {
    public var confidence : double_t = 0.0
    public var labelstr : NSString = ""
}

class DetailViewController: UIViewController, UITextViewDelegate {
    
    
    var index = 0
    var label : UILabel = UILabel()
    var MainStyleColor = UIColor.init(red: 51/255, green: 113/255, blue: 255/255, alpha: 1)
    fileprivate var downLoader = DownLoader()
    
    //data
    let demoData = "麦基砍28+18+5却充满寂寞 纪录之夜他的痛阿联最懂新浪体育讯上天对每个人都是公平的，贾维尔-麦基也不例外。今天华盛顿奇才客场104-114负于金州勇士，麦基就好不容易等到“捏软柿子”的机会，上半场打出现象级表现，只可惜无法一以贯之。最终，麦基12投9中，得到生涯最高的28分，以及平生涯最佳的18个篮板，另有5次封盖。此外，他11次罚球命中10个，这两项也均为生涯最高。如果在赛前搞个竞猜，上半场谁会是奇才阵中罚球次数最多的球员？若有人答曰“麦基”，不是恶搞就是脑残。但半场结束，麦基竟砍下22分(第二节砍下14分)。更罕见的，则是他仅出手7次，罚球倒是有11次，并命中了其中的10次。此外，他还抢下11个篮板，和勇士首发五虎总篮板数持平；他还送出3次盖帽，竟然比勇士全队上半场的盖帽总数还多1次！麦基为奇才带来了什么？除了得分方面异军突起，在罚球线上杀伤对手，率队紧咬住比分，用封盖威慑对手外，他在篮板上的贡献最为关键。众所周知，篮板就是勇士的生命线。3月3日的那次交锋前，时任代理主帅的兰迪-惠特曼在赛前甚至给沃尔和尼克-杨二人下达“篮板不少于10个”的硬性指标。惠特曼没疯，他深知守住了篮板阵地，就如同扼住了勇士的咽喉。上次交锋拿下16个篮板的大卫-李就说：“称霸篮板我们取胜希望就大些。我投中多少球无所谓，但我一定要保护篮板”。最终，勇士总篮板数以54-40领先。但今天，半场结束麦基却让李仅有5个篮板进账。造成这种局面的关键因素是身高。在2.11米的安德里斯-比德林斯伤停后，勇士内线也更为迷你。李2.06米，弗拉迪米尔-拉德马诺维奇2.08米，艾派-乌杜2.08米，路易斯-阿蒙德森2.06米。由此，2.13米又弹跳出众的麦基也就有些鹤立鸡群了。翻开本赛季中锋篮板效率榜，比德林斯位居第13位，麦基第20，李则是第31。可惜，麦基出彩不但超出了勇士预期，也超出了奇才预期，注定不可长久。第三节李砍下12分，全场26投15中砍下33分12个篮板5次助攻，麦基的防守不利则被放大。2分11秒，奇才失误，蒙塔-埃利斯带球直冲篮下，面对麦基的防守，他华丽的篮下360度转身上篮命中。全场掌声雷动下，麦基的身影却无比落寞。下半场麦基有多困顿？篮板被对方追上，全场勇士篮板仅落后2个；上半场拉风的罚球，在下半场竟然一次也没有。和阿联此役先扬后抑的表现如出一辙，麦基也吃尽了奇才内线缺兵少将的苦头。(魑魅)"
    var textarray : [textClassif] = [textClassif]()
    
    //UI
    let inputTextView = UITextView()
    let outputTextView = UITextView()
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    convenience init(index : intmax_t) {
        self.init()
        self.index = index
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (index == 0) {
            setNTRUI()
        } else {
            setTextClassUI()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setNTRUI() {
        setTestButton()
        setInputUI()
        setOutputUI()
        setDesUI()
    }
    func setTextClassUI() {
        setTestButton()
        setInputUI()
        setOutputUI()
        //setDesUI()
    }
    
    
    //NTR
    func setInputUI() {
        let inputTitle = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 190, y: 20, width: 100, height: 20))
        inputTitle.text = "测试文本"
        inputTitle.backgroundColor = UIColor.white
        inputTitle.textColor = UIColor.black
        inputTitle.font = UIFont.systemFont(ofSize: 14)
        inputTitle.numberOfLines = 1
        inputTitle.textAlignment = .left
        inputTitle.adjustsFontSizeToFitWidth = true
        self.view.addSubview(inputTitle)
        
        inputTextView.frame = CGRect(x: self.view.frame.size.width/2 - 190, y: 50, width: 380, height: 150)
        inputTextView.backgroundColor = UIColor.init(red: 243/255, green: 243/255, blue: 243/255, alpha: 1)
        inputTextView.font = UIFont.systemFont(ofSize: 14.0)
        //inputTextView.font = UIFont(name: "Helvetica-Bold", size: 14.0)
        inputTextView.textAlignment = .left
        inputTextView.isEditable = true
        inputTextView.returnKeyType = UIReturnKeyType.done
        inputTextView.keyboardType = UIKeyboardType.default
        inputTextView.isScrollEnabled = true
        
        inputTextView.text = "输入测试文段"
        inputTextView.textColor = UIColor.lightGray
        inputTextView.delegate = self
        inputTextView.layer.borderColor = UIColor.lightGray.cgColor
        inputTextView.layer.borderWidth = 0.5
        inputTextView.tag = 0
        self.view.addSubview(self.inputTextView)
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.tag == 0 {
            if textView.textColor == UIColor.lightGray {
                textView.text = nil
                textView.textColor = UIColor.black
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.tag == 0 {
            if textView.text.isEmpty {
                textView.text = "输入测试文段"
                textView.textColor = UIColor.lightGray
            }
        }
    }
    
    
    func setOutputUI() {
        let outputTitle = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 190, y: 210, width: 100, height: 20))
        outputTitle.text = "测试结果"
        outputTitle.backgroundColor = UIColor.white
        outputTitle.font = UIFont.systemFont(ofSize: 14)
        outputTitle.numberOfLines = 1
        outputTitle.textAlignment = .left
        outputTitle.adjustsFontSizeToFitWidth = true
        self.view.addSubview(outputTitle)
        
        outputTextView.frame = CGRect(x: self.view.frame.size.width/2 - 190, y: 240, width: 380, height: 150)
        outputTextView.backgroundColor = UIColor.init(red: 243/255, green: 243/255, blue: 243/255, alpha: 1)
        outputTextView.font = UIFont.systemFont(ofSize: 14.0)
        //outputTextView.font = UIFont(name: "Helvetica-Bold", size: 14.0)
        outputTextView.textAlignment = .left
        outputTextView.isEditable = false
        outputTextView.returnKeyType = UIReturnKeyType.done
        outputTextView.keyboardType = UIKeyboardType.default
        outputTextView.isScrollEnabled = true
        outputTextView.text = ""
        outputTextView.textColor = UIColor.black
        outputTextView.delegate = self
        outputTextView.layer.borderColor = UIColor.lightGray.cgColor
        outputTextView.layer.borderWidth = 0.5
        
        self.view.addSubview(self.outputTextView)
        
    }
    
    func setDesUI() {
        let desTitle = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 190, y: 400, width: 100, height: 20))
        desTitle.text = "结果含义解释"
        desTitle.backgroundColor = UIColor.white
        desTitle.textColor = UIColor.black
        desTitle.font = UIFont.systemFont(ofSize: 14)
        desTitle.numberOfLines = 1
        desTitle.textAlignment = .left
        desTitle.adjustsFontSizeToFitWidth = true
        self.view.addSubview(desTitle)
        let cardView = UIView(frame: CGRect(x: self.view.frame.size.width/2 - 190, y: 430, width: 380, height: 130))
        
        cardView.backgroundColor = UIColor.white
        cardView.layer.borderColor = UIColor.lightGray.cgColor
        cardView.layer.borderWidth = 0.5
        cardView.layer.shadowColor = UIColor.black.cgColor
        //设置透明度
        cardView.layer.shadowOpacity = 0.2
        //设置阴影半径
        cardView.layer.shadowRadius = 3.0
        cardView.layer.shadowOffset = CGSize.init(width: 10.0, height: 10.0)
        
        self.view.addSubview(cardView)
        
        let describeText = UILabel(frame: CGRect(x: 10 , y: 5, width: 360, height: 120))
        describeText.text = "在中国西部偏远山区山高谷深的地方，溜索曾是民众的重要交通工具。近年来，四川在阿坝、甘孜、凉山、广元、绵阳等地山区相继建设的“溜索改桥”项目，让这里的“蜀道难”成为历史"
        describeText.backgroundColor = UIColor.white
        describeText.textColor = UIColor.lightGray
        describeText.font = UIFont.systemFont(ofSize: 12)
        describeText.numberOfLines = 0
        describeText.textAlignment = .left
        describeText.adjustsFontSizeToFitWidth = true
        cardView.addSubview(describeText)
        
        
    }
    
    
    func setTestButton() {
        let testButton = UIButton()
        
        testButton.frame = CGRect(x: self.view.frame.size.width/2 - 190, y: 660, width: 380 , height: 50)
        let text = "测试数据"
        testButton.backgroundColor = MainStyleColor
        testButton.setTitle(text as String, for: .normal)
        testButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        testButton.setTitleColor(UIColor.white, for: .normal)
        testButton.setTitleColor(MainStyleColor, for: .highlighted)
        testButton.layer.shadowColor = UIColor.black.cgColor
        //设置透明度
        testButton.layer.shadowOpacity = 0.5
        //设置阴影半径
        testButton.layer.shadowRadius = 5.0
        testButton.layer.shadowOffset = CGSize.init(width: 0.0, height: 5.0)
        testButton.addTarget(self, action: #selector(runModal(_:)), for: .touchUpInside)
        self.view.addSubview(testButton)
        
        let downButton = UIButton()
        
        downButton.frame = CGRect(x: self.view.frame.size.width/2 - 190, y: 590, width: 380 , height: 50)
        let down = "训练"
        downButton.backgroundColor = MainStyleColor
        downButton.setTitle(down as String, for: .normal)
        downButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)

        downButton.setTitleColor(UIColor.white, for: .normal)
        downButton.setTitleColor(MainStyleColor, for: .highlighted)
        downButton.layer.shadowColor = UIColor.black.cgColor
        //设置透明度
        downButton.layer.shadowOpacity = 0.5
        //设置阴影半径
        downButton.layer.shadowRadius = 5.0
        downButton.layer.shadowOffset = CGSize.init(width: 0.0, height: 5.0)
        downButton.addTarget(self, action: #selector(downloadModelFile(_:)), for: .touchUpInside)
        self.view.addSubview(downButton)
        
    }
    
    @objc func downloadModelFile(_ button: UIButton) {
        print("fasfdsfdsfdsfdas")
//        let url = NSURL(string: "/Users/bytedance/Desktop/tensorflow_lite_swift_demo-master/text_swift_demo/model.tflite")
//        self.downLoader.downLoader(url: url!)
        
        
        
    }
    @objc func runModal(_ button: UIButton) {
        print("色特")
        if index == 0 {//NPL
            
            
            let text = inputTextView.text
            if text!.isEmpty  {
                print("text is empty")
            } else {
                let result = self.getResult(text! as NSString)
                print(result)
                
            }
            
            
            
            
            
        } else if index == 1 {
            
            
            
           
            if inputTextView.text.isEmpty {
                print("输入文本为空")
            } else {
                
                TextClassifier.shared.loadInfo {
                    TextClassifier.shared.runModel(with: self.inputTextView.text) { (res) in
                        print(res)
                        for i in 0..<res.count {
                            let item = textClassif()
                            item.confidence = double_t(res[i].confidence)
                            item.labelstr = res[i].label as NSString
                            self.textarray.append(item)
                        }
                        var result = ""
                        if self.textarray.isEmpty {
                            print("运行错误，结果为空")
                        } else {
                            print("运行成功")
                            for i in 0..<self.textarray.count {
                                
                                
                                result = result.appendingFormat("label : %@  confidence : %lf . \n", self.textarray[i].labelstr,self.textarray[i].confidence)
                                print(self.textarray[i].confidence)
                                //resdata
                                self.outputTextView.text = result
                            }
                            
                        }
                    }
                }
                
            }

        }
        
    }
    
    
    func getResult(_ text:NSString) -> NSString {
        let parameters: Dictionary = ["sentence" : text]
        let urlString = "http://127.0.0.1:5000/demoone"
        //let parameters: Dictionary = ["key" : "93c921ea8b0348af8e8e7a6a273c41bd"]
        
                AF.request(urlString, method: .post,  parameters:parameters) .responseJSON {response  in
                    //print("result==\(response.result)")
        //有错误就打印错误，没有就解析数据
                    if let Error = response.error
                    {
                        print(Error)
                    }
                    else if let jsonValue = response.data
                    {
                        print("code = \(jsonValue)")
                        let  datajosn:NSDictionary  = response.value as! NSDictionary

                        let status = datajosn["status"] as!String
                        //print(finaldata["status"])
                       var final = ""
                        var LOCarray =  datajosn["LOC"] as! Array<String>
                        
                        final = final.appendingFormat("LOC : %@ \n" ,datajosn["LOC"] as! Array<String>)
                        //final = final.appendingFormat("ORG : %@ \n", finaldata["ORG"])
                        //final = final.appendingFormat("ORG : %@ \n", finaldata["PER"])
                        
                    }

                }
        return ""
        
    }
    
    
    
    
    


}
