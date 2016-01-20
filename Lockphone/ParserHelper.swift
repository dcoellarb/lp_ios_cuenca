//
//  ParserHelper.swift
//  Lockphone
//
//  Created by Daniel Coellar on 12/30/15.
//  Copyright © 2015 lockphone. All rights reserved.
//

import Foundation
import Parse
import RxSwift

class ParserHelper {


    //Device
    func getPhoneInfo(fromDevice: PFObject?) -> Observable<PhoneInfoModel>{
        return create { observer in
            let phoneInfo = PhoneInfoModel()
            if let device = fromDevice {
                phoneInfo.id = device.objectId
                phoneInfo.imei = device["imei"] as? String
                phoneInfo.brand = device["brand"]["brand"] as? String
                phoneInfo.model = device["brand"]["model"] as? String
                
                if let insurance = device["brand"]["insurance"] as? Double {
                    if let year = device["brand"]["year"] as? Int {
                        if let depreciation = device["brand"]["depreciation"] as? Int {
                            if let deductible = device["brand"]["deductible"] as? Double {
                                if let price = device["brand"]["price"] as? Double {
                                    phoneInfo.valorAsegurado = insurance
                                    let date = NSDate()
                                    let calendar = NSCalendar.currentCalendar()
                                    let components = calendar.components(.Year, fromDate: date)
                                    let currentYear = components.year
                                    let years = currentYear - year
                                    let depreciationRate = Double((depreciation * years)/100)
                                    let actualDepreciation = Double(phoneInfo.valorAsegurado * depreciationRate)
                
                                    phoneInfo.deducible = actualDepreciation + deductible
                                    phoneInfo.valorRecibir = insurance - phoneInfo.deducible
                                    phoneInfo.costoMensual = price
                                }
                            }
                        }
                    }
                }
            }
            
            observer.on(.Next(phoneInfo))
            observer.on(.Completed)
            return NopDisposable.instance
        }
    }
}
