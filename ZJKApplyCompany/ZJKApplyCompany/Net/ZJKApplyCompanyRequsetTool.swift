//
//  ZJKCYRequest.swift
//  ZJKApplyCompany
//
//  Created by 陈宇 on 2023/2/6.
//

import Foundation
import ZJNetWork
import MJExtension
import ZJAESEnDecrypt
import JYBProgressHUD
 class ZJKApplyCompanyRequsetTool: ZJNetWorkRequest {
    static var baseUrl:String = ""
    
    static var token = ""
    static var header:[String: AnyHashable] {
        get {
            return ["sign":ZJAESEncrypt.zjaes_Sign(),"Authorization": "Bearer " + ZJKApplyCompanyRequsetTool.token]
        }
    }
    
    
    static func getUrl() -> String {
         return  ZJKApplyCompanyRequsetTool.baseUrl.contains("192.168") ? "\(ZJKApplyCompanyRequsetTool.baseUrl)" + "/" + "logistics/operate/organization" : "\(ZJKApplyCompanyRequsetTool.baseUrl)" + "/zjkj-app/" + "logistics/operate/organization"
    }
    
     
    static func loadData(block:@escaping ((Any?)->())) {
        JYBProgressHUD.show()
        var request = ZJNetWorkRequest()
        request.requestType = .GET
        request.parameters = [String : Any]()
        request.header = ZJKApplyCompanyRequsetTool.header
        request.requestSerializerType = .JSON
        request.responseSerializerType = .JSON
        request.requestUrl = ZJKApplyCompanyRequsetTool.getUrl()
        request.requestNW { req, data in
            JYBProgressHUD.hide()
            block(data)
        } failure: { req, error, data in
            JYBProgressHUD.hide()
            if let errorDict:[String: AnyObject] = req?.responseData.faileResponse as? [String: AnyObject], let msg:String = errorDict["msg"] as? String {
                JYBProgressHUD.showMessage(msg)
            }
            block(nil)
        } completion: { status in
            
        }

    }
}
