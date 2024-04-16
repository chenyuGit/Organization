//
//  CYChooseCompanyHeaderCell.swift
//  SGBProject
//
//  Created by 陈宇 on 2022/6/6.
//  Copyright © 2022 dtx. All rights reserved.
//

import UIKit
import SnapKit
import ZJKKit
@objcMembers
class ZJKApplyCompanyHeaderCell: UICollectionViewCell {
    var isCurrentCompany = false
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(self.titleLab)
        self.contentView.addSubview(self.rightImg)
        
        self.titleLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(5)
            make.centerY.equalToSuperview()

        }
                
        self.rightImg.snp.makeConstraints { make in
            make.left.equalTo(self.titleLab.snp.right)
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(9)
            make.height.equalTo(15)
        }
    }
    
    func loadData(name: String, isCurrentCompany:Bool) {
        
        self.rightImg.isHidden = isCurrentCompany
        self.titleLab.textColor = isCurrentCompany ? UIColor.hex("969696") : UIColor.hex("5792FD")
        self.isCurrentCompany = isCurrentCompany
        self.titleLab.text = name
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let size = self.titleLab.text?.size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .regular)]) ?? CGSize.zero
        let att = super.preferredLayoutAttributesFitting(layoutAttributes);
        att.frame = CGRect(x: 0, y: 0, width: (size.width * ZJKFontManager.share().fontSizeRatio + 18), height: 42)
        return att;
    }
    
    
    lazy var titleLab: UILabel = {
        let instance = UILabel()
        instance.textColor = UIColor.hex("969696")
        instance.zjk_dynamicFont = UIFont.systemFont(ofSize: 15, weight: .regular)
        return instance
    }()
    
    lazy var rightImg: UIImageView = {
        let instance = UIImageView()
        instance.image = UIImage.zjkCompany_imageNamed("ac_right")
        return instance
    }()
}
