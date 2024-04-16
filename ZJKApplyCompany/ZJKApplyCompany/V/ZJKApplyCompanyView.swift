//
//  CYChooseCompanyView.swift
//  SGBProject
//
//  Created by 陈宇 on 2022/6/6.
//  Copyright © 2022 dtx. All rights reserved.
//

import UIKit
import SnapKit


protocol ZJKApplyCompanyProtocol: AnyObject{
    
    
    func tableViewCellForRow(model:AnyObject) ->(String,Bool,Bool,Bool)?
    
    func tableViewDidSelectItemAt(model:AnyObject,indexPath: IndexPath)
    
    func collectionViewDidSelectItemAt(model:ZJKApplyCompanyModel)

}

@objcMembers
class ZJKApplyCompanyView: UIView {

    var tableHeadHeight = 10.0
    var tableHeaderViewColor = UIColor.hex("F5F5F5")
    var tableCellheight = 44.0
    var collectionViewHeight = 50
    var headItemList = [ZJKApplyCompanyModel]() {
        didSet {
                    
            if headItemList.count > 0 {
                self.updateUI()
                self.headView.reloadData()
                self.layoutIfNeeded()
                var contentOffX = self.headView.contentSize.width - self.headView.frame.size.width;
                if contentOffX < 0 {
                    contentOffX = 0
                }
                self.headView.setContentOffset( CGPoint(x: contentOffX, y: self.headView.contentOffset.y), animated: false)
            }
            
        }
    }
    var dataList = [[AnyObject]]()
    
    weak var delegate: ZJKApplyCompanyProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.headView)
        self.addSubview(self.tableView)
        
        self.headView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(self.collectionViewHeight)
        }
        
        self.tableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.bottom.right.equalToSuperview()
        }
        
    }
   

    func updateUI() {
        if self.headView.isHidden == true {
            self.headView.isHidden = false
            self.tableView.snp.remakeConstraints { make in
                make.top.equalTo(self.headView.snp.bottom)
                make.left.bottom.right.equalToSuperview()

            }
        }
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var tableView : UITableView = {
        let tableView = UITableView.init(frame: .zero, style: .plain)
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = .none;
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.backgroundColor = UIColor.hex("F5F5F5")
        tableView.register(ZJKApplyCompanyItemCell.self  , forCellReuseIdentifier: "ZJKApplyCompanyItemCell")
        return tableView
    }()
    
    
    
    
    lazy var headView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.estimatedItemSize = CGSize.init(width: 60, height: 50);
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: UIScreen.main.bounds.width/2 - 14)
        let instance = UICollectionView(frame:CGRect.zero, collectionViewLayout: layout)
        instance.backgroundColor = UIColor.clear
        instance.dataSource = self
        instance.delegate = self
        instance.showsVerticalScrollIndicator = false
        instance.showsHorizontalScrollIndicator = false
        instance.register(ZJKApplyCompanyHeaderCell.self, forCellWithReuseIdentifier: "ZJKApplyCompanyHeaderCell")
        instance.isHidden = true
        return instance
    }()
}


extension ZJKApplyCompanyView: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataList.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        NSLog("section:\(section)---rowCount:\(self.dataList[section].count)")
        return self.dataList[section].count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell:ZJKApplyCompanyItemCell = (tableView.dequeueReusableCell(withIdentifier: "ZJKApplyCompanyItemCell", for: indexPath) as? ZJKApplyCompanyItemCell) ?? ZJKApplyCompanyItemCell()
        if let data = self.delegate?.tableViewCellForRow(model: self.dataList[indexPath.section][indexPath.row]) {
            cell.loadData(info: data.0, isHiddenRightImg: data.1, isChooseStatus: data.2, isUserInteractionEnabled:data.3)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.dataList[indexPath.section][indexPath.row]
        self.delegate?.tableViewDidSelectItemAt(model: model, indexPath: indexPath)
        self.tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 10))
        view.backgroundColor = UIColor.hex("F5F5F5")
        return self.dataList[section].count > 0 ? view : nil
       
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.headItemList.count == 0 {
            return  CGFloat.leastNonzeroMagnitude
        }
        return self.dataList[section].count > 0 ? 10 : CGFloat.leastNonzeroMagnitude
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
}


extension ZJKApplyCompanyView: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return self.headItemList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell:ZJKApplyCompanyHeaderCell = (collectionView.dequeueReusableCell(withReuseIdentifier: "ZJKApplyCompanyHeaderCell", for: indexPath) as? ZJKApplyCompanyHeaderCell) ?? ZJKApplyCompanyHeaderCell()
        let title = self.headItemList[indexPath.row].name ?? ""
        cell.loadData(name: title, isCurrentCompany: indexPath.row == self.headItemList.count - 1 ? true : false)
        return cell
    }


    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if indexPath.row  == self.headItemList.count - 1 {
            return
        }
        self.headItemList = self.headItemList.dropLast(self.headItemList.count - 1 - indexPath.row)
        let model = self.headItemList.last ?? ZJKApplyCompanyModel()

        self.dataList[1] = model.contacts ?? [ZJKOperatorModel]()
        
        guard let modelList = model.children, modelList.count > 0 else {
            // 企业下没有子公司或则部门的
            self.dataList[0].removeAll()
            return
        }
        self.dataList[0] = modelList
       
        self.delegate?.collectionViewDidSelectItemAt(model: model)

        
        self.tableView.reloadData()
    }
    
}


