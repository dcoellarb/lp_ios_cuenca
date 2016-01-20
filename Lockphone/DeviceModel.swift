//
//  DeviceModel.swift
//  Lockphone
//
//  Created by Daniel Coellar on 1/4/16.
//  Copyright © 2016 lockphone. All rights reserved.
//

import Foundation
import UIKit

class DeviceModel {
    
    static let sharedInstance = DeviceModel()
    
    private var identifier : String
    let modelName : String
    let imageName : String
    
    init(){
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        self.identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8 where value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        switch identifier {
        case "iPod5,1":                                 modelName = "iPod Touch 5"
        case "iPod7,1":                                 modelName = "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     modelName = "iPhone 4"
        case "iPhone4,1":                               modelName = "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  modelName = "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  modelName = "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  modelName = "iPhone 5s"
        case "iPhone7,2":                               modelName = "iPhone 6"
        case "iPhone7,1":                               modelName = "iPhone 6 Plus"
        case "iPhone8,1":                               modelName = "iPhone 6s"
        case "iPhone8,2":                               modelName = "iPhone 6s Plus"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":modelName = "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           modelName = "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           modelName = "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           modelName = "iPad Air"
        case "iPad5,3", "iPad5,4":                      modelName = "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           modelName = "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           modelName = "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           modelName = "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      modelName = "iPad Mini 4"
        case "iPad6,7", "iPad6,8":                      modelName = "iPad Pro"
        case "AppleTV5,3":                              modelName = "Apple TV"
        case "i386", "x86_64":                          modelName = "Simulator"
        default:                                        modelName = "iPhone 6s Plus"
        }

        switch identifier {
        case "iPhone5,1", "iPhone5,2":                  imageName = "5"
        case "iPhone5,3", "iPhone5,4":                  imageName = "5c"
        case "iPhone6,1", "iPhone6,2":                  imageName = "5s"
        case "iPhone7,2":                               imageName = "6"
        case "iPhone7,1":                               imageName = "6 Plus"
        case "iPhone8,1":                               imageName = "6s"
        case "iPhone8,2":                               imageName = "6s Plus"
        default:                                        imageName = "6s Plus"
        }
    }
}