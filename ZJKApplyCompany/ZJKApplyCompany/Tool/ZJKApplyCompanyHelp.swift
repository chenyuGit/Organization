//
//  ExtensionTool.swift
//  ZJKApplyCompany
//
//  Created by 陈宇 on 2023/2/3.
//

import Foundation

@objcMembers
public class ZJKApplyCompanyHelp: NSObject {
    
    
    static func zjkCompanyBundle() -> Bundle {
        let bundlePath = URL(fileURLWithPath: Bundle(for: Self.self).resourcePath ?? "").appendingPathComponent("imageSources.bundle").path
        let bundle = Bundle(path: bundlePath)
        return bundle ?? Bundle.main
    }
}


extension UIColor {
    
    static func hex(_ hex: String, alpha: CGFloat = 1.0) -> UIColor {
        guard let hex = Int(hex, radix: 16) else { return UIColor.clear }
        return UIColor(red: ((CGFloat)((hex & 0xFF0000) >> 16)) / 255.0,
                       green: ((CGFloat)((hex & 0x00FF00) >> 8)) / 255.0,
                       blue: ((CGFloat)((hex & 0x0000FF) >> 0)) / 255.0,
                       alpha: alpha)
    }
}


public extension UIImage{
    /// 获取图片方法
    static func zjkCompany_imageNamed(_ name: String?) -> UIImage {
        let image = UIImage(named: name ?? "", in: ZJKApplyCompanyHelp.zjkCompanyBundle(), compatibleWith: nil)
        return image ?? UIImage()
    }
    
    
}
