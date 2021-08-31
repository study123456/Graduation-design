//
//  KWAnswerViewController.swift
//  小学100以内口算练习
//
//  Created by Mr.Hu on 2021/6/9.
//

import UIKit
class KWAnswerViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    private let opCellID:String = "OPViewCell"
    private let fillCellID:String = "FillViewCell"
    private let resultCellID:String = "ResultViewCell"

    
    var answerType = 0// 0.选择题 1.填空题 2.答题完成
    var viewIndex = 0//当前第几道题 viewIndex+1
    var answerTopLabel:UILabel!
    var headerLabel:UILabel!
    var footerLabel:UILabel!
    var preButton:UIButton!
    var nextButton:UIButton!
    var completeBtn:UIButton!
    var timeLabel:UILabel!
    var timer : Timer!
    
    var questions :NSMutableArray = NSMutableArray()
    
    var selIndex:Int = -1
    

    lazy var tableView:UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UINib.init(nibName:"KWOPViewCell", bundle: nil), forCellReuseIdentifier: opCellID)
        tableView.register(UINib.init(nibName:"KWFillViewCell", bundle: nil), forCellReuseIdentifier: fillCellID)
        tableView.register(UINib.init(nibName:"KWResultViewCell", bundle: nil), forCellReuseIdentifier: resultCellID)

        
        

        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if answerType == 0 {
            self.title = "答题(选择题)";
        }else{
            self.title = "答题(填空题)";
        }
        self.view.backgroundColor = .white;
        self.navigationItem.backBarButtonItem?.tintColor = .black;
        let leftBtn:UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "ow_mgr_NavLeft"), style: .plain, target: self, action: #selector(actionBack))
        leftBtn.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem=leftBtn;
        
        createUI()
        
        //加载模拟数据
        loadContent()
    
    }
    
    func createUI() {
        view.addSubview(tableView)
        
        let view_W:CGFloat = self.view.frame.size.width
        let view_H:CGFloat = 90.0

        ///tableHeaderView
        let headerView = UIView(frame: CGRect.init(x:0, y: 0, width:view_W, height:view_H))
        
        answerTopLabel = UILabel(frame: CGRect.init(x:0, y:0, width:view_W/2, height:40))
        answerTopLabel.font = UIFont.boldSystemFont(ofSize: 22);
        answerTopLabel.textColor = kColor
        answerTopLabel.textAlignment = .center
        headerView.addSubview(answerTopLabel);
        
        timeLabel = UILabel(frame: CGRect.init(x:view_W/2-16, y:0, width:view_W/2, height:40))
        timeLabel.font = UIFont.boldSystemFont(ofSize: 14);
        timeLabel.textColor = UIColor.red
        timeLabel.textAlignment = .right
        headerView.addSubview(timeLabel);
        
        headerLabel = UILabel(frame: CGRect.init(x:20, y:40, width:view_W, height:30))
        headerLabel.font = UIFont.boldSystemFont(ofSize: 17);
        headerView.addSubview(headerLabel);
        tableView.tableHeaderView = headerView;
        
        ///tableFooterView
        let btn_X:CGFloat = 20.0
        let btn_Y:CGFloat = 40.0
        let btn_W:CGFloat = 80.0
        let btn_H:CGFloat = 40.0
        
        let footerView = UIView(frame: CGRect.init(x:0, y: 0, width:view_W, height:view_H))
        
        preButton = UIButton(frame: CGRect(x: btn_X, y: btn_Y, width: btn_W, height: btn_H));
        preButton .setTitle("上一题", for: .normal)
        preButton.addTarget(self, action: #selector(previousAction), for: .touchUpInside)
        setupBntProperty(btn: preButton)
        nextButton = UIButton(frame: CGRect(x: view_W - btn_X - btn_W, y: btn_Y, width: btn_W, height: btn_H));
        nextButton .setTitle("下一题", for: .normal)
        setupBntProperty(btn: nextButton)
        nextButton.addTarget(self, action: #selector(nextAction), for: .touchUpInside)
        completeBtn = UIButton(frame: CGRect(x: kScreenWidth/2-btn_W/2, y: btn_Y, width: btn_W, height: btn_H));
        completeBtn .setTitle("完成答题", for: .normal)
        completeBtn.addTarget(self, action: #selector(completeAction), for: .touchUpInside)
        setupBntProperty(btn: completeBtn)
        
        footerView .addSubview(preButton)
        footerView .addSubview(completeBtn)
        footerView .addSubview(nextButton)
        tableView.tableFooterView = footerView;
        completeBtn.isHidden = true
        
    }
    
    func setupBntProperty(btn:UIButton) {
        btn .setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.backgroundColor = kColor
        btn.layer.cornerRadius = 2
        btn.layer.masksToBounds = true
    }
    
    @objc func actionBack(){
        timer?.invalidate()
        timer = nil
        self.navigationController?.popViewController(animated:true);
    }
    
    func loadContent(){
        //加载配置数据
        let list = analogData()
        for obj in list {
            let dict:NSDictionary = obj as! NSDictionary
            let tModel = testPaperModel()
            tModel.title = (dict["title"] as! String)
            if (dict["option"] != nil) {
                tModel.opSelects = (dict["option"] as! NSArray)
            }
            tModel.answer_right = (dict["right"] as! String)
            self.questions .add(tModel)
        }
        
        //初始数据
        let tModel:testPaperModel = self.questions[viewIndex] as! testPaperModel
        
        if self.answerType == 1 {
            headerLabel.isHidden = true
        }else{
            headerLabel.text = "1、".appending(tModel.title!)
        }
        answerTopLabel.text = "共"+String(questions.count)+"题" + " " + "答对0道题"
        preButton.isHidden = true
        self.tableView.reloadData()
        
        self.timeMethon()
    }
    
    override func viewDidLayoutSubviews() {
        tableView.frame = view.bounds
    }
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if viewIndex > questions.count || questions.count == 0{
            return 0
        }
        
        if self.answerType == 1 {
            return 1
        }else if(self.answerType == 2){
            return self.questions.count
        }else{
            let tModel:testPaperModel = questions[viewIndex] as! testPaperModel
            return tModel.opSelects!.count;
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if self.answerType == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: fillCellID, for: indexPath) as! KWFillViewCell
            
            let tModel:testPaperModel = questions[viewIndex] as! testPaperModel
            
            cell.cellLabel.text = String(viewIndex+1) + "、".appending(tModel.title!)
            
            return cell
        }else if self.answerType == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: opCellID, for: indexPath) as! KWOPViewCell
            
            let tModel:testPaperModel = questions[viewIndex] as! testPaperModel
            cell.cellTitleLabel.text = tModel.opSelects?[indexPath.row] as? String
            var imgName:String = "hover_normal"
            cell.bgView.layer.borderColor = kLineColor.cgColor
            if indexPath.row == selIndex {
                imgName = "ow_hover_selected"
                cell.bgView.layer.borderColor = kColor.cgColor
            }
            cell.cellImgV.image = UIImage(named:imgName);
            return cell
        }else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: resultCellID) as! KWResultViewCell
            let tModel:testPaperModel = questions[indexPath.row] as! testPaperModel
            cell.rTitleLabel?.text = tModel.title
            
            if tModel.is_answer == true {
                cell.wrLabel.text = "回答正确"
                cell.wrLabel.textColor = UIColor.green
            }else{
                cell.wrLabel.text = "回答错误"
                cell.wrLabel.textColor = UIColor.red
            }
            
            
            if tModel.opSelects == nil {
                cell.rightLabel.text = "正确答案:" + tModel.answer_right!
            }else{
                let right = tModel.opSelects![Int(tModel.answer_right!)! - 1] as! String
                cell.rightLabel.text = "正确答案:" + right
            }
            
            return cell
        }
        

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.answerType == 1 {
            return 117
        }
        return 50
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selIndex = indexPath.row
        self.tableView .reloadData()
           
    }
    
    //上一题事件
    @objc func previousAction(sender:UIButton){

        nextButton.isHidden = false
        
        if viewIndex + 1 == 2 {
            preButton.isHidden = true
        }

        
        viewIndex-=1
        if self.answerType == 0 {
            let nModel:testPaperModel = questions[viewIndex] as! testPaperModel
            headerLabel.text = String(viewIndex+1).appending("、").appending(nModel.title!)
        }
        
        tableView.reloadData()
        performAnimation(subtType: .fromLeft)

    }

    ///下一题事件
    @objc func nextAction(sender: UIButton) {



        var count = 0
        
        if self.answerType == 1 {
            
            preButton.isHidden = false

            
            //填空题 答题逻辑
            let cell:KWFillViewCell = tableView .cellForRow(at: IndexPath.init(row: 0, section: 0)) as! KWFillViewCell
            
            print(cell.cellTextField.text as Any)
            
            if  cell.cellTextField.text?.count == 0 {
                self.view.makeToast("请输入答案", duration: 1.5, position: .center)
                return
            }

            
            let tModel:testPaperModel = questions[viewIndex] as! testPaperModel
            let isRight = tModel.answer_right == cell.cellTextField.text!
            
            cell.cellTextField.text = nil;
        
            if isRight {
                tModel.is_answer = true
                self.view.makeToast("答题正确", duration: 0.5, position: .center)
            }else{
                tModel.is_answer = false
                self.view.makeToast("答题错误", duration: 0.5, position: .center)
            }

            
            
            for obj in questions {
                let model:testPaperModel = obj as! testPaperModel;
                if model.is_answer == true {
                    count+=1
                }
            }
            
            
            
            
            //进入下一题
            viewIndex+=1
            
        }else{
            
            preButton.isHidden = false

                
            //选择题 答题逻辑
            if selIndex == -1 {
                self.view.makeToast("请选择答案", duration: 1.5, position: .center)
                return
            }
            
            let tModel:testPaperModel = questions[viewIndex] as! testPaperModel
            //校验答案
            let isRight = String(selIndex+1) == tModel.answer_right
            if isRight {
                tModel.is_answer = true
                self.view.makeToast("答题正确", duration: 0.5, position: .center)
            }else{
                tModel.is_answer = false
                self.view.makeToast("答题错误", duration: 0.5, position: .center)
            }
            
            selIndex = -1
            
            for obj in questions {
                let model:testPaperModel = obj as! testPaperModel;
                if model.is_answer == true {
                    count+=1
                }
            }
            
            viewIndex+=1
            let nModel:testPaperModel = questions[viewIndex] as! testPaperModel
            headerLabel.text = String(viewIndex+1).appending("、").appending(nModel.title!)
            
        }
        
        let isFinish = viewIndex+1 == questions.count;
        nextButton.isHidden = isFinish
        completeBtn.isHidden = !isFinish
        //更新标题
        answerTopLabel.text = "共"+String(questions.count)+"题" + " | " + "答对"+String(count)+"道题"
        self.tableView.reloadData()
        
        performAnimation(subtType: .fromRight)
    }
    
    @objc func completeAction(){
        
        if self.answerType == 2 {
            timer?.invalidate()
            timer = nil
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        var count = 0
        
        if self.answerType == 1 {
            //填空题 答题逻辑
            let cell:KWFillViewCell = tableView .cellForRow(at: IndexPath.init(row: 0, section: 0)) as! KWFillViewCell
            
            print(cell.cellTextField.text as Any)
            
            if  cell.cellTextField.text?.count == 0 {
                self.view.makeToast("请输入答案", duration: 1.5, position: .center)
                return
            }
            let tModel:testPaperModel = questions[viewIndex] as! testPaperModel
            let isRight = tModel.answer_right == cell.cellTextField.text!
            cell.cellTextField.text = nil;
            if isRight {
                tModel.is_answer = true
                self.view.makeToast("答题正确", duration: 0.5, position: .center)
            }else{
                tModel.is_answer = false
                self.view.makeToast("答题错误", duration: 0.5, position: .center)
            }

        }else{
            
            //选择题 答题逻辑
            if selIndex == -1 {
                self.view.makeToast("请选择答案", duration: 1.5, position: .center)
                return
            }
            
            let tModel:testPaperModel = questions[viewIndex] as! testPaperModel
            //校验答案
            let isRight = String(selIndex+1) == tModel.answer_right
            if isRight {
                tModel.is_answer = true
                self.view.makeToast("答题正确", duration: 0.5, position: .center)
            }else{
                tModel.is_answer = false
                self.view.makeToast("答题错误", duration: 0.5, position: .center)
            }
            
            selIndex = -1
        }
        
        for obj in questions {
            let model:testPaperModel = obj as! testPaperModel;
            if model.is_answer == true {
                count+=1
            }
        }
        
        //更新标题
        answerTopLabel.text = "共"+String(questions.count)+"题" + " | " + "答对"+String(count)+"道题"
        
        
        timer?.invalidate()
        timer = nil
        
        timeLabel.text = "用时：" + timeLabel.text!
        
        
        headerLabel.isHidden = true
        preButton.isHidden = true
        nextButton.isHidden = true

        completeBtn .setTitle("重新答题", for: .normal)
        self.answerType = 2;
        self.tableView .reloadData()
     
        performAnimation(subtType: .fromRight)
    }
    
    func performAnimation(subtType:CATransitionSubtype) {
        // 初始化动画的持续时间，类型和子类型
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = .push
        transition.subtype = subtType
        self.tableView.layer.add(transition, forKey: nil)
    }
 
       
       func timeMethon() -> Void {
           self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timeAction(_:)), userInfo: nil, repeats: true)
           RunLoop.current.add(self.timer!, forMode: RunLoop.Mode.common)
//           self.timer?.fireDate = Date.distantFuture
       }
       var second : Int = 0
       
       @objc func timeAction(_ time : Timer) -> Void {
          
           second += 1
        
        if second > 60 {
            let min = second / 60
            let sec = second % 60

            timeLabel.text = String(min) + "分".appending(String(sec) + "秒")
        }else{
            timeLabel.text = String(second) + "秒"
        }
        print(second)
       }
    
       
       deinit {
           print("vc被释放了")
            timer?.invalidate()
            timer = nil
       }

    func analogData()->NSArray {
        
        if answerType == 1 {
            return [
                                ["title" : "1 + 9 = ",
                                 "right" : "10",
                                ],
                                ["title" : "2 + 3 + 4 = ",
                                 "right" : "9",
                                ],
                                ["title" : "4 + 55 = ",
                                 "right" : "59",
                                ],
                                ["title" : "43 - 2 -10 = ",
                                 "right" : "31",
                                ],
                                ["title" : "2 x 22 x 1 = ",
                                 "right" : "44",
                                ],
                                ["title" : "5 x 11 = ",
                                 "right" : "55",
                                ],
                                ["title" : "20 ÷ 2 = ",
                                 "right" : "10",
                                ],
                                ["title" : "1 X (2 + 50) = ",
                                 "right" : "52",
                                ],
            ]
        }else{
            return [
                                ["title" : "8 x 8 + 1 = ()",
                                 "option" :  ["A.65","B.90","C.49","D.64"],
                                 "right" : "1",
                                ],
                                ["title" : "2 x (2 + 22) = ()",
                                 "option" :  ["A.12","B.21","C.88","D.2"],
                                 "right" : "3",
                                ],
                                ["title" : "15 ÷ 5 = ()",
                                 "option" :  ["A.3","B.45","C.20","D.1"],
                                 "right" : "1",
                                ],
                                ["title" : "15 x 3 = ()",
                                 "option" :  ["A.12","B.45","C.20","D.1"],
                                 "right" : "2",
                                ],
                                ["title" : "2 x 1 = ()",
                                 "option" :  ["A.12","B.21","C.1","D.2"],
                                 "right" : "4",
                                ],
                                ["title" : "20 ÷ 5 + 50 = ()",
                                 "option" :  ["A.12","B.45","C.54","D.1"],
                                 "right" : "3",
                                ],
            ]
        }
    }
    
}




class testPaperModel: NSObject {
    var title: String?  //题目
    var opSelects: NSArray?//选择题可选项
    var is_answer: Bool? //是否答对
    var answer_right: String?//正确答案
    var flag: Bool? //是否答过
    var textFieldText: String?
    
}
