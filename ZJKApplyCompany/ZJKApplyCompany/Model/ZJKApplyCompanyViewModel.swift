//
//  JYBHYChooseViewModel.swift
//  ZJKApplyCompany
//
//  Created by 陈宇 on 2023/2/3.
//

import Foundation

@objcMembers
public class ZJKApplyCompanyViewModel:NSObject {
    //申请单位
    public var appUnit: ZJKApplyCompanyModel = ZJKApplyCompanyModel()
    // 申请部门
    public var applyDepartment:ZJKApplyCompanyModel = ZJKApplyCompanyModel()
    // 经办人
    public var handledPerson:ZJKOperatorModel =  ZJKOperatorModel()
    public var handledPersonList:[ZJKOperatorModel] =  [ZJKOperatorModel]()

    //点击单位部门经办人进入的type 0:单位 1:部门 2:经办人
    public var enterType: Int = 0
    // 选择的顶部单位部门列表
    public var selectUnitList: [ZJKApplyCompanyModel] = [ZJKApplyCompanyModel]()
    
    // 找到最下级子公司，并返回公司列表
    func findLastUnit(modelList: [ZJKApplyCompanyModel]) ->[ZJKApplyCompanyModel] {
        var newList:[ZJKApplyCompanyModel] = modelList
        if let lastModel = newList.last  {
            if lastModel.type == "1" {
                newList.removeLast()
                return self.findLastUnit(modelList: newList)
            }
        }
        return newList
    }
    
    //获取当前经办人所属的部门数组
    func getDepartMentIdsAddNames(list:[ZJKApplyCompanyModel]) {
        var ids = Array<String>()
        var names = Array<String>()
        for item in list {
            if item.type == "1" {
                ids.append(item.id ?? "")
                names.append(item.name ?? "")
            }
        }
        self.applyDepartment.ids = ids
        self.applyDepartment.names = names
        
    }
    
}
