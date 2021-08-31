//
//  ViewController.swift
//  小学100以内口算练习
//
//  Created by Mr.Hu on 2021/6/9.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var startAnswer: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "小学100以内口算练习"
        
        let selectBtn = UIButton.init(type: .custom)
        selectBtn.setTitle("选择题", for: .normal)
        selectBtn.tag = 0
        view.addSubview(selectBtn)
        selectBtn.backgroundColor = kColor
        selectBtn.layer.cornerRadius = 25
        selectBtn.layer.masksToBounds = true
        selectBtn.frame = CGRect.init(x: 100, y:200, width: 200, height: 50)
        selectBtn.addTarget(self, action: #selector(answerAction), for: .touchUpInside)
        
        
        let answerBtn = UIButton.init(type: .custom)
        answerBtn.setTitle("填空题", for: .normal)
        answerBtn.tag = 1
        view.addSubview(answerBtn)
        answerBtn.backgroundColor = kColor
        answerBtn.layer.cornerRadius = 25
        answerBtn.layer.masksToBounds = true
        answerBtn.frame = CGRect.init(x: 100, y:300, width: 200, height: 50)
        answerBtn.addTarget(self, action: #selector(answerAction), for: .touchUpInside)
        
    }
    
    //答题事件
    @objc func answerAction(sender: UIButton) {
        let answerVc = KWAnswerViewController()
        answerVc.answerType = sender.tag;
        self.navigationController!.pushViewController(answerVc, animated: true);
    }
}
