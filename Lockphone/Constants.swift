//
//  Constants.swift
//  Lockphone
//
//  Created by Daniel Coellar on 12/28/15.
//  Copyright © 2015 lockphone. All rights reserved.
//

import Foundation
import UIKit

struct UserDefatulsKeys {
    static let localImei = "localImei"
    static let localDeviceId = "localDeviceId"
    static let localNombre = "localNombre"
    static let localDireccion = "localDireccion"
    static let localTelefono = "localTelefono"
    static let localRucCI = "localRucCI"
    static let localEmail = "localEmail"
    static let localPassword = "localPassword"
    
}

struct Colors {
    static let white = UIColor.whiteColor()
    static let red = UIColor.redColor()
    static let redDisabled = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.7)
    static let lightergray = UIColor(red: (245.0/250.0), green: (245.0/250.0), blue: (250.0/255.0), alpha: 1.0)
    static let lightgray = UIColor.lightGrayColor()
    static let gray = UIColor.grayColor()
    static let darkgray = UIColor.darkGrayColor()
    static let darkergray = UIColor.darkGrayColor()//UIColor(red: 50, green: 50, blue: 50, alpha: 1)
    static let paypal = UIColor(red: 0.0, green: (156.0/250.0), blue: (222.0/255.0), alpha: 1.0)
    static let stripe = UIColor(red: 0.0, green: (175.0/250.0), blue: (225.0/255.0), alpha: 1.0)
}

struct Font {
    static let lightFontName = "Avenir-Light"
    static let regularFontName = "Avenir-Roman"
    static let boldFontName = "Avenir-Medium"
    static let extraBoldFontName = "Avenir-Heavy"
    
    
    static func regularFontWithSize(size: CGFloat) -> UIFont {
        return UIFont(name: regularFontName, size: size) ?? UIFont.systemFontOfSize(size)
    }
    static func lightFontWithSize(size: CGFloat) -> UIFont {
        return UIFont(name: lightFontName, size: size) ?? UIFont.systemFontOfSize(size)
    }
    static func boldFontWithSize(size: CGFloat) -> UIFont {
        return UIFont(name: boldFontName, size: size) ?? UIFont.systemFontOfSize(size)
    }
    static func extraBoldFontWithSize(size: CGFloat) -> UIFont {
        return UIFont(name: extraBoldFontName, size: size) ?? UIFont.systemFontOfSize(size)
    }
}