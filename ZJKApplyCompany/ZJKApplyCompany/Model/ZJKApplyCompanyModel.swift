//
//  ZJKApplyCompanyModel.swift
//  SGBProject
//
//  Created by 陈宇 on 2022/6/6.
//  Copyright © 2022 dtx. All rights reserved.
//

import UIKit

@objcMembers
public class ZJKApplyCompanyModel: NSObject {
    // 子企业或部门
    public var children:[ZJKApplyCompanyModel]?
    
    // 部门或企业下的人
    public var contacts: [ZJKOperatorModel]?
    
    //企业编号
    public var no: String?
   
    //企业下的人数
    public var count = 0
    
    //id 查询经办人使用
    public var id: String?
    
    //企业/团队名称
    public var name: String?
    
    //父级ID
    public var parentId: String?
    
    //团队编号
    public var teamNo: String?
    
    //类型 0-主团队/企业  2-子团队/企业  1-部门
    public var type: String = "0"
    
    
    public var names = [String]()
    
    public var ids = [String]()
    
    public override static func mj_objectClassInArray() -> [AnyHashable : Any]! {
        return [
                "children": ZJKApplyCompanyModel.self,
                "contacts": ZJKOperatorModel.self
        ]
    }
    
    public override class func mj_replacedKeyFromPropertyName() -> [AnyHashable : Any]! {
        return ["no": ["no","comNo"]]
    }
}


@objcMembers
public class ZJKOperatorModel: NSObject {
    //经办人所属企业集合
    //@objc public var department: [String]?
    //所属企业的名称
    //@objc public var departmentName: String?
    //当前所属id
    //@objc public var departmentId: [String]?
    
    //经办人姓名
    @objc public var name: String?
    //经办人电话
    @objc public var phone: String?
    ///经办人用户编号
    @objc public var no: String?
    
    public override class func mj_replacedKeyFromPropertyName() -> [AnyHashable : Any]! {
        return ["no": ["no","memberNo"]]
    }
}
