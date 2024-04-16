//
//  ViewController.swift
//  ZJKApplyCompany
//
//  Created by chenyu715110699@gmail.com on 02/03/2023.
//  Copyright (c) 2023 chenyu715110699@gmail.com. All rights reserved.
//

import UIKit
import ZJKApplyCompany
import AFNetworking
class ViewController: UIViewController {

    var model = ZJKApplyCompanyViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(self.showType)
        self.view.addSubview(self.switchBtn)
        self.view.addSubview(self.companybtn)
        self.view.addSubview(self.departMenbtn)
        self.view.addSubview(self.personbtn)

    }
    
    @objc func pushAction(sender: UIButton) {
        let vc = ZJKApplyCompanyVC(viewModel: self.model, baseUrl: "https://api.jybtech.cn", token: " eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzUxMiJ9.eyJzdWIiOiIxNTU5NDQ2OTI1ODY5MTkxMTY4Iiwic2NvcGUiOiJkZWZhdWx0IiwiaXNzIjoiMTc3ODA2ODI4MzciLCJsb2dpbiI6MTcwOTE3NzEwOH0.dYczG628G39QhKuVY-Yaid2ckKn1GjKhuqTS_Q2gJJLT1miKCUbv9uGWwDz5Hu6ZidvRfkXuYczC3wsCAZBw9SJGS7gj_cSE-XO4RGKKkqB9g4KT4XdDB27eo421Yzy1PJOy14Qum0wKGoVK1hd39p3KkM6K8mCmqYVEaHM78_E")
        vc.isMultipleChoice = self.switchBtn.isOn ? true : false
        vc.multipleChoiceMaxLimit = 3
        self.model.enterType = sender.tag - 1000
        let p1 = ZJKOperatorModel()
        p1.no = "1405801534045949952"
        let p2 = ZJKOperatorModel()
        p2.no = "1412264338680582144"
        let p3 = ZJKOperatorModel()
        p3.no = "1412316830239952896"
        self.model.handledPersonList  = [p1,p2,p3]
        vc.returnBlock  = {[weak self] (viewModel) in
            guard let self = self else{return}
            self.model = viewModel
            self.companybtn.setTitle("公司：\(viewModel.appUnit.name!)", for: .normal)
            self.departMenbtn.setTitle("部门：\(viewModel.applyDepartment.name!)", for: .normal)
            var name = ""
            viewModel.handledPersonList.map { model in
                name = name + (model.name ?? "")
            }
            self.personbtn.setTitle("人：\(name)", for: .normal)

        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    lazy var showType: UILabel = {
        let instance = UILabel(frame: CGRect(x:180, y: 160, width: 100, height: 30))
        instance.text = "多选"
        return instance
    }()
    
    lazy var switchBtn: UISwitch = {
        let instance = UISwitch(frame: CGRect(x: 220, y: 160, width: 100, height: 100))
        return instance
    }()
    
    lazy var companybtn: UIButton = {
        let instance = UIButton(type: .custom)
        instance.frame = CGRect(x: 0, y: 200, width: self.view.frame.width, height: 100)
        instance.backgroundColor = UIColor.blue
        instance.setTitle("公司", for: .normal)
        instance.tag = 1000
        instance.addTarget(self, action: #selector(pushAction), for: .touchUpInside)
        return instance
    }()
    
    lazy var departMenbtn: UIButton = {
        let instance = UIButton(type: .custom)
        instance.frame = CGRect(x: 0, y: 310, width: self.view.frame.width, height: 100)
        instance.backgroundColor = UIColor.blue
        instance.setTitle("部门", for: .normal)
        instance.tag = 1001
        instance.addTarget(self, action: #selector(pushAction), for: .touchUpInside)
        return instance
    }()
    
    lazy var personbtn: UIButton = {
        let instance = UIButton(type: .custom)
        instance.frame = CGRect(x: 0, y: 420, width: self.view.frame.width, height: 100)
        instance.backgroundColor = UIColor.blue
        instance.setTitle("经办人", for: .normal)
        instance.tag = 1002
        instance.addTarget(self, action: #selector(pushAction), for: .touchUpInside)
        return instance
    }()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

