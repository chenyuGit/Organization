//
//  CYChooseCompanyItemCell.swift
//  SGBProject
//
//  Created by 陈宇 on 2022/6/6.
//  Copyright © 2022 dtx. All rights reserved.
//

import UIKit
import SnapKit
import ZJKKit
@objcMembers
class ZJKApplyCompanyItemCell: UITableViewCell {

    var chooseBlock:(()->())?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = .white
        self.contentView.addSubview(self.chooseBtn)
        self.contentView.addSubview(self.nameAddNumberLabel)
        self.contentView.addSubview(self.rightImg)
        self.contentView.addSubview(self.alphaView)
        self.contentView.addSubview(self.lineView)
        self.chooseBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(15)
        }
        
        self.nameAddNumberLabel.snp.makeConstraints { make in
            make.left.equalTo(self.chooseBtn.snp.right).offset(5)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-30)
        }
        
        self.rightImg.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-15)
            make.centerY.equalToSuperview()
            make.width.equalTo(9)
            make.height.equalTo(15)
        }
        
        self.alphaView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.lineView.snp.makeConstraints { make in
            make.bottom.right.equalToSuperview()
            make.height.equalTo(0.5)
            make.left.equalToSuperview().offset(35)
        }
    }
    

    
    func loadData(info:String, isHiddenRightImg:Bool, isChooseStatus:Bool, isUserInteractionEnabled:Bool) {
        self.rightImg.isHidden = !isHiddenRightImg
        self.nameAddNumberLabel.text = info
        self.chooseBtn.isSelected = isChooseStatus
        self.alphaView.isHidden = isUserInteractionEnabled
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    lazy var chooseBtn: UIButton = {
        let instance = UIButton(type: .custom)
        instance.setImage(UIImage.zjkCompany_imageNamed("applyCompany_noChoose"), for: .normal)
        instance.setImage(UIImage.zjkCompany_imageNamed("applyCompany_choose"), for: .selected)
        instance.isUserInteractionEnabled = false
        return instance
    }()

    lazy var alphaView: UIView = {
        let instance = UIView()
        instance.backgroundColor = .white
        instance.alpha = 0.7
        instance.isHidden = true
        return instance
    }()
    lazy var lineView: UIView = {
        let instance = UIView()
        instance.backgroundColor = UIColor.hex("EDEDED")
        return instance
    }()
    
    lazy var nameAddNumberLabel: UILabel = {
        let instance = UILabel()
        instance.zjk_dynamicFont = UIFont.systemFont(ofSize: 15, weight: .regular)
        instance.textColor = UIColor.hex("333333")
        instance.lineBreakMode = .byTruncatingTail;

        return instance
    }()
    
    lazy var rightImg: UIImageView = {
        let instance = UIImageView()
        instance.image = UIImage.zjkCompany_imageNamed("ac_right")
        return instance
    }()
}
