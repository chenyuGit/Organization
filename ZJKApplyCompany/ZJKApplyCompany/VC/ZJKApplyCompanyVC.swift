//
//  CYChooseCompanyVC.swift
//  SGBProject
//
//  Created by 陈宇 on 2022/6/6.
//  Copyright © 2022 dtx. All rights reserved.
//

import UIKit
import JYBProgressHUD
import SnapKit
import AFNetworking
import ZJNetWork
import ZJKKit

@objcMembers
public class ZJKApplyCompanyVC: UIViewController {

    public var returnBlock:((ZJKApplyCompanyViewModel)->())?
    public var leftImage: UIImage?
    var viewModel = ZJKApplyCompanyViewModel()
    
    var chooseCompanyModel = ZJKApplyCompanyModel()

    var chooseDepartMentModel = ZJKApplyCompanyModel()

    var choosePeopleModel = ZJKOperatorModel() {
        didSet {
            if self.choosePeopleModel.no != nil  {
                self.submitBtn.alpha = 1
            }else {
                self.submitBtn.alpha = 0.5
            }
        }
    }
    
    //多选字段
    public var isMultipleChoice = false
    // 多选最大限制
    public var multipleChoiceMaxLimit = 20
    // 多选最大限制提示
    public var multipleChoiceMaxLimitTip = "抱歉，消息接受人数超限"

    var choosePeopleModelList = [ZJKOperatorModel]() {
        didSet {
            if self.choosePeopleModelList.count > 0  {
                self.submitBtn.alpha = 1
            }else {
                self.submitBtn.alpha = 0.5
            }
        }
    }

    
    public init(viewModel:ZJKApplyCompanyViewModel?, baseUrl: String, token: String) {
        if let model  = viewModel {
            self.viewModel = model
        }
        ZJKApplyCompanyRequsetTool.baseUrl = baseUrl
        ZJKApplyCompanyRequsetTool.token = token
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.setNav()
        self.title = "请选择申请单位"
        self.view.backgroundColor = .white
        self.view.addSubview(self.chooseCompanyView)
        let btmView = UIView()
        btmView.backgroundColor = .white
        let lineView = UIView()
        lineView.backgroundColor = UIColor.zjk_color(withHexString: "EDEDED")
        
        view.addSubview(btmView)
        btmView.addSubview(lineView)
        btmView.addSubview(submitBtn)
        let btmSpace: CGFloat = ZJKSafeAreaBottomHeight() > 0 ? 0 : 8
        
        lineView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(1/UIScreen.main.scale)
        }

        
        
        btmView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(40 * ZJKFontManager.share().layoutRatio + 8 + btmSpace+ZJKSafeAreaBottomHeight())
        }
        self.submitBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(40  * ZJKFontManager.share().layoutRatio)
            make.top.equalToSuperview().offset(8)
        }
        
        self.chooseCompanyView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.bottom.equalTo(btmView.snp.top)
        }
        
        self.chooseCompanyView.dataList  = [[ZJKApplyCompanyModel](),[ZJKOperatorModel]()]
        self.chooseCompanyView.headItemList = [ZJKApplyCompanyModel]()
        if self.viewModel.selectUnitList.count > 0 {
            self.aginChoose()
        }else {
            if self.isMultipleChoice && self.viewModel.handledPersonList.count > 0 {
                self.choosePeopleModelList = self.viewModel.handledPersonList
                self.submitBtn.setTitle(self.choosePeopleModelList.count > 0 ? "提交(已选\(self.choosePeopleModelList.count)人)" : "提交", for: .normal)

            }
            
            self.loadCompany(isFirst: true)
        }
        
        self.zjkapp_mainGradientLayerBy()(self.submitBtn.gradientLayer)
        
    }
    
    func setNav() {
        
        if #available(iOS 15.0, *) {
            UITableView.appearance().sectionHeaderTopPadding = 0
        }
        
        
        if self.leftImage != nil {
            let backButton = UIButton(type: .custom)
            backButton.setImage(self.leftImage, for: .normal)
            backButton.addTarget(self, action: #selector(popToRootView), for: .touchUpInside)
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        }else{
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.zjkCompany_imageNamed("btn_cancel"), style: .plain, target: self, action: #selector(popToRootView))
        }
        
        edgesForExtendedLayout = []
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = UIColor.hex("EF4033")
            appearance.shadowColor = .clear
            appearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17), NSAttributedString.Key.foregroundColor: UIColor.white]
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
            navigationController?.navigationBar.standardAppearance = appearance
            
        }
    }
    
    @objc func popToRootView() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func zjkapp_mainGradientLayerBy() -> ((_ layer: CAGradientLayer?) -> CAGradientLayer) {
        return { [weak self] value in
            if value == nil {
                return CAGradientLayer()
            }
            value!.startPoint = CGPoint(x: 0, y: 0.5)
            value!.endPoint = CGPoint(x: 1, y: 0.5)
            value!.colors = [UIColor.hex("EF4033").cgColor, UIColor.hex("FF6155").cgColor]
            value!.locations = [0, 1.0]
            return value!
        }
    }
    
    //再次选择进入
    func aginChoose() {
        
        var chooseHeadList:[ZJKApplyCompanyModel] =  self.viewModel.selectUnitList
        let lastModel:ZJKApplyCompanyModel = chooseHeadList.last ?? ZJKApplyCompanyModel();
        self.title = chooseHeadList.first?.name ?? ""
        
        var newList =  self.viewModel.findLastUnit(modelList:chooseHeadList)
        guard let companyModel = newList.last else {return}
        self.chooseCompanyModel = companyModel
        
        if self.isMultipleChoice && self.viewModel.handledPersonList.count > 0 {
            self.choosePeopleModelList = self.viewModel.handledPersonList
        }

        switch self.viewModel.enterType {
        case 0:
            //选择的公司直接是总公司
            if companyModel.type == "0"  {
                self.loadCompany()
                return
            }else {
                newList.removeLast()
                self.chooseCompanyView.headItemList = newList
            }
            break
        case 1:
            if lastModel.type == "1" {
                self.chooseDepartMentModel = lastModel
                chooseHeadList.removeLast()
            }
            self.chooseCompanyView.headItemList = chooseHeadList

            break
        case 2:
            self.chooseCompanyView.headItemList = chooseHeadList
            //判断当前是否是在部门层级下
            if lastModel.type == "1" {
                self.chooseDepartMentModel = lastModel
            }
            if self.isMultipleChoice {
                self.choosePeopleModelList = self.viewModel.handledPersonList
            }else {
                self.choosePeopleModel.no = self.viewModel.handledPerson.no
            }
            break
        default:
            break
        }

        self.chooseCompanyView.dataList[0] = self.chooseCompanyView.headItemList.last?.children ?? [ZJKApplyCompanyModel]()
        self.chooseCompanyView.dataList[1] = self.chooseCompanyView.headItemList.last?.contacts ?? [ZJKOperatorModel]()
        self.chooseCompanyView.tableView.reloadData()
        
    }
   
    //提交
    @objc func submitAction() {
        
        //没有选择单位
        if self.isMultipleChoice {
            if self.choosePeopleModelList.count == 0 {
                return
            }
        }else {
            if  self.choosePeopleModel.no == nil {
                return
            }
        }
        
        self.viewModel = ZJKApplyCompanyViewModel()
    
        self.viewModel.selectUnitList = self.chooseCompanyView.headItemList
        // 申请单位
        self.viewModel.appUnit = self.chooseCompanyModel
       
        // 申请部门
        self.viewModel.applyDepartment = self.chooseDepartMentModel
        self.viewModel.getDepartMentIdsAddNames(list: self.chooseCompanyView.headItemList)
        //self.viewModel.applyDepartment.id = self.chooseDepartMentModel.id ?? ""
        //self.viewModel.applyDepartment.name = self.chooseDepartMentModel.name ?? "该人员未分配部门"
        if self.viewModel.applyDepartment.name == nil {
            self.viewModel.applyDepartment.name = "该人员未分配部门"
        }
        // 经办人
        if self.isMultipleChoice {
            self.viewModel.handledPersonList = self.choosePeopleModelList
        }else {
            self.viewModel.handledPerson = self.choosePeopleModel

        }
                
        if let block = self.returnBlock {
            block(self.viewModel)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    lazy var chooseCompanyView: ZJKApplyCompanyView = {
        let instance = ZJKApplyCompanyView()
        instance.delegate = self
        return instance
    }()
    

    lazy var submitBtn: ZJKGradientButton = {
        let instance = ZJKGradientButton()
        instance.setTitle("提交", for: .normal)
        instance.titleLabel?.zjk_dynamicFont = UIFont.systemFont(ofSize: 16, weight: .regular)
        instance.setTitleColor(UIColor.white, for: .normal)
        instance.addTarget(self, action: #selector(submitAction), for: .touchUpInside)
        instance.alpha = 0.5
        instance.layer.cornerRadius = 5
        return instance
    }()
    

}

extension ZJKApplyCompanyVC {
        
    func loadCompany(isFirst: Bool = false) {
        ZJKApplyCompanyRequsetTool.loadData {[weak self] data in
            guard let self = self else {return}
            if let tempArr = data as? Array<[ String: AnyObject]> {
                guard let  modelList = ZJKApplyCompanyModel.mj_objectArray(withKeyValuesArray: tempArr) as? [ZJKApplyCompanyModel] else {
                    return
                }
                if isFirst {
                    self.setDefaltData(modelList: modelList)
                }else {
                    self.chooseCompanyView.dataList[0] = modelList
                }
                

            }else if let dict:NSMutableDictionary = data as? NSMutableDictionary {
                guard  let  model = ZJKApplyCompanyModel.mj_object(withKeyValues: dict) else {
                    return
                }
                if isFirst {
                    self.setDefaltData(modelList: [model])

                }else {
                    self.chooseCompanyView.dataList[0] = [model]

                }

            }
            self.chooseCompanyView.tableView.reloadData()

        }
       
    }

    func setDefaltData(modelList: [ZJKApplyCompanyModel]) {
        if self.viewModel.appUnit.id?.count ?? 0 > 0 {
            var selectCompanyList = [ZJKApplyCompanyModel]()
            var newList =  self.getCurrentCompanyOrDepartMent(selectList: &selectCompanyList, modelList: modelList, id: self.viewModel.appUnit.id ?? "")
            
            var selectDepartList = [ZJKApplyCompanyModel]()
            var departMentid = self.viewModel.applyDepartment.id ?? ""
            if departMentid == "" {
                departMentid = self.viewModel.applyDepartment.ids.last ?? ""
            }
            var newsss =  self.getCurrentCompanyOrDepartMent(selectList: &selectDepartList, modelList: selectCompanyList.last?.children ?? [ZJKApplyCompanyModel](), id: departMentid)
            self.viewModel.selectUnitList = selectCompanyList + selectDepartList
            self.aginChoose()
            
        }else {
            self.chooseCompanyView.dataList[0] = modelList

        }
    }
    
    func getCurrentCompanyOrDepartMent(selectList:inout [ZJKApplyCompanyModel], modelList:[ZJKApplyCompanyModel], id: String) -> Bool {
        
        for model in modelList {
            if model.id == id {
                selectList.insert(model, at: 0)
                return true
            }else {
                if let newList  = model.children {
                    if self.getCurrentCompanyOrDepartMent(selectList: &selectList, modelList: newList, id: id) {
                        selectList.insert(model, at: 0)
                        return true
                    }
                }
            }
        }
        return false
    }
    
    
}


extension ZJKApplyCompanyVC:ZJKApplyCompanyProtocol {
        
   
    
    func tableViewCellForRow(model: AnyObject) -> (String, Bool, Bool, Bool)? {
        
        guard let newModel:ZJKApplyCompanyModel = model as? ZJKApplyCompanyModel else {
           
            guard let newModel:ZJKOperatorModel = model as? ZJKOperatorModel else {
                return nil
            }
            var chooseStatus = false
            
            if isMultipleChoice {
                let chooseModelList = self.choosePeopleModelList.filter { chooseModel in
                    if newModel.no == chooseModel.no {
                        return true
                    }else {
                        return false
                    }
                }
                
                let canNotChooseModelList = self.viewModel.handledPersonList.filter { chooseModel in
                    if newModel.no == chooseModel.no {
                        return true
                    }else {
                        return false
                    }
                }
                
                
                let canNotChooseStatus = canNotChooseModelList.count > 0 ? false : true
                chooseStatus = chooseModelList.count > 0 ? true : false
                return (newModel.name ?? "", false, chooseStatus, canNotChooseStatus)

            }else {
                 chooseStatus = ( newModel.no == self.choosePeopleModel.no ? true : false)
                if chooseStatus {
                    self.choosePeopleModel = newModel
                }
                return (newModel.name ?? "", false, chooseStatus, true)

            }
        }
        
        //是否选中状态
        var chooseStatus = false
        if newModel.type == "1" && newModel.id == self.chooseDepartMentModel.id {
            chooseStatus = true
            self.chooseDepartMentModel = newModel
        }
        if (newModel.type == "2" && newModel.id == self.chooseCompanyModel.id) || (newModel.type == "0" && newModel.id == self.chooseCompanyModel.id) {
            chooseStatus = true
            self.chooseCompanyModel = newModel
        }
        
        //是否可置灰
        var isUserInteractionEnabled = true
        if newModel.children?.count == 0 && newModel.contacts?.count == 0 {
            isUserInteractionEnabled = false
        }
        var infoStr = ""
        
        //需求： 主企业/团队后不显示人数
        if newModel.type == "0" {
            infoStr = "\(newModel.name ?? "")"
        }else {
            infoStr = "\(newModel.name ?? "") \(newModel.count > 0 ? " (\(newModel.count))" : "(0)")"
        }
        
        return (infoStr, true, chooseStatus,isUserInteractionEnabled)
        
    }
    
    func tableViewDidSelectItemAt(model: AnyObject, indexPath: IndexPath) {
        
        switch model.self {
        case is ZJKApplyCompanyModel:
            guard let newModel:ZJKApplyCompanyModel = model as? ZJKApplyCompanyModel else {return}
            
            if newModel.children?.count == 0 && newModel.contacts?.count == 0 && newModel.count == 0 {
                return
            }
            
            if newModel.type == "0" {
                self.title = newModel.name
            }
            
            self.chooseCompanyView.headItemList.append(newModel)
            
            // 重新选择了部门或公司 ，已选择的人取消选择
            if !self.isMultipleChoice {
                self.choosePeopleModel = ZJKOperatorModel()
            }
            
            self.chooseCompanyView.dataList[1] = newModel.contacts ?? [ZJKOperatorModel]()

            
            // 点击的是部门
            if newModel.type == "1" {
                // 选择的部门和当前选择的公司是同一层级时，选择该部门 取消子公司选择状态，选择公司为父级公司
                if newModel.parentId == self.chooseCompanyModel.parentId {
                    self.chooseCompanyModel = (self.chooseCompanyView.headItemList[self.chooseCompanyView.headItemList.count - 2]  as? ZJKApplyCompanyModel) ?? ZJKApplyCompanyModel()
                }
                
                self.chooseDepartMentModel = newModel
            }else {
                //点击的是公司
                self.chooseCompanyModel = newModel
                self.chooseDepartMentModel = ZJKApplyCompanyModel()
            }
            
            guard let modelList = newModel.children, modelList.count > 0 else {
                // 单位下没有子级单位
                self.chooseCompanyView.dataList[0].removeAll()
                return
            }
            self.chooseCompanyView.dataList[0] = modelList
            
        
            //点击的是人
        case is ZJKOperatorModel:
            guard let newModel:ZJKOperatorModel = model as? ZJKOperatorModel else {return}
            let superModel:ZJKApplyCompanyModel = self.chooseCompanyView.headItemList.last as? ZJKApplyCompanyModel ?? ZJKApplyCompanyModel()
            
            // 选择单位下没有部门的经办人，取消同级的部门，
            if superModel.id == self.chooseDepartMentModel.parentId {
                if superModel.type == "1" {
                    self.chooseDepartMentModel = superModel
                }else {
                    self.chooseDepartMentModel = ZJKApplyCompanyModel()
                }
            }
            
            //选择单位下没有部门的经办人，选择的公司变更为上级单位
            if superModel.id == self.chooseCompanyModel.parentId {
                self.chooseCompanyModel = superModel
            }
            if isMultipleChoice {
                
                let chooseModelList = self.choosePeopleModelList.filter { chooseModel in
                    if newModel.no == chooseModel.no {
                        return true
                    }else {
                        return false
                    }
                }
                
                let submitPersonList = self.viewModel.handledPersonList.filter { chooseModel in
                    if newModel.no == chooseModel.no {
                        return true
                    }else {
                        return false
                    }
                }
                if chooseModelList.count > 0 {
                    if submitPersonList.count == 0 {
                        self.choosePeopleModelList.removeAll(where: {$0 == newModel})
                    }
                }else {
                    if self.choosePeopleModelList.count < self.multipleChoiceMaxLimit {
                        self.choosePeopleModelList.append(newModel)
                    }else {
                        JYBProgressHUD.showMessage(self.multipleChoiceMaxLimitTip)
                    }
                }
                                
            }else {
                self.choosePeopleModel = newModel
            }
            if self.isMultipleChoice {
                self.submitBtn.setTitle(self.choosePeopleModelList.count > 0 ? "提交(已选\(self.choosePeopleModelList.count)人)" : "提交", for: .normal)
            }
            
        default:
            break
        }
    }
    
    func collectionViewDidSelectItemAt(model: ZJKApplyCompanyModel) {
        if !self.isMultipleChoice {
            self.choosePeopleModel = ZJKOperatorModel()

        }
        self.chooseDepartMentModel = ZJKApplyCompanyModel()
        // 部门
        if model.type == "1" {
            self.chooseDepartMentModel = model
        }else {
            //点击的是公司
            self.chooseCompanyModel = model
        }
    }
    
    
}
