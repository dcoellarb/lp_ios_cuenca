//
//  PhoneInfoViewModel.swift
//  Lockphone
//
//  Created by Daniel Coellar on 12/23/15.
//  Copyright © 2015 lockphone. All rights reserved.
//

import Foundation
import RxSwift

class PhoneInfoViewModel{

    private var phoneInfo = PhoneInfoModel()
    var deviceId: String? {
        get{
            return self.phoneInfo.id
        }
    }
    var imei: String? {
        get{
            return self.phoneInfo.imei
        }
    }
    var brand: String? {
        get{
            return self.phoneInfo.brand
        }
    }
    var model: String? {
        get{
            return self.phoneInfo.model
        }
    }
    var valorAsegurado: String? {
        get{
            return self.formatCurrency(self.phoneInfo.valorAsegurado)
        }
    }
    var deducible: String? {
        get{
            return self.formatCurrency(self.phoneInfo.deducible)
        }
    }
    var valorRecibir: String? {
        get{
            return self.formatCurrency(self.phoneInfo.valorRecibir)
        }
    }
    var costoMensual: String? {
        get{
            return self.formatCurrency(self.phoneInfo.costoMensual)
        }
    }
    var deviceImageName = DeviceModel.sharedInstance.imageName
    
    
    
    func setPhoneInfo() -> Observable<PhoneInfoModel>{
        return self.getLocalIMEI()
            .flatMap{(imei: String?) -> Observable<PhoneInfoModel> in
                if let imei = imei{
                    return self.getParseDataFromImei(imei)
                }else{
                    return self.getLocalDeviceId()
                        .flatMap {(deviceid: String?) -> Observable<PhoneInfoModel> in
                            if let id = deviceid{
                                return self.getParseDataFromDeviceId(id)
                            }else{
                                return self.createDeviceId()
                            }
                    }
                }
        }
    }
    
    private func getLocalIMEI() -> Observable<String?> {
        return create{observer in
            let defaults = NSUserDefaults.standardUserDefaults()
            if let imei = defaults.objectForKey(UserDefatulsKeys.localImei) as? String {
                self.phoneInfo.imei = imei
                debugPrint("local imei found")
            }
            
            observer.on(.Next(self.phoneInfo.imei))
            observer.on(.Completed)
            return NopDisposable.instance
        }
    }
    private func getLocalDeviceId() -> Observable<String?> {
        return create{observer in
            let defaults = NSUserDefaults.standardUserDefaults()
            if let deviceId = defaults.objectForKey(UserDefatulsKeys.localDeviceId) as? String {
                self.phoneInfo.id = deviceId
                debugPrint("local device id found")
            }
            
            observer.on(.Next(self.phoneInfo.id))
            observer.on(.Completed)
            return NopDisposable.instance
        }
    }
    private func getParseDataFromImei(imei: String) -> Observable<PhoneInfoModel> {
        return create{observer in
            DataService.sharedInstance.getDeviceWithImei(imei).subscribeNext{ phoneInfo in
                self.phoneInfo = phoneInfo
                observer.on(.Next(phoneInfo))
                observer.on(.Completed)
                
            }
            
            return NopDisposable.instance
        }
    }
    private func getParseDataFromDeviceId(id: String) -> Observable<PhoneInfoModel> {
        return create{observer in
            DataService.sharedInstance.getDevice(id).subscribeNext{ phoneInfo in
                self.phoneInfo = phoneInfo
                observer.on(.Next(phoneInfo))
                observer.on(.Completed)

            }
            
            return NopDisposable.instance
        }
    }
    private func createDeviceId() -> Observable<PhoneInfoModel> {
        return create{observer in
            
            DataService.sharedInstance.createDevice().subscribeNext{ phoneInfo in
                self.phoneInfo = phoneInfo
                if let id = self.phoneInfo.id {
                    let defaults = NSUserDefaults.standardUserDefaults()
                    defaults.setValue(id, forKey: UserDefatulsKeys.localDeviceId)
                }
                
                observer.on(.Next(phoneInfo))
                observer.on(.Completed)
            }

            return NopDisposable.instance
            
        }
    }
    
    private func formatCurrency(varlor: Double) -> String? {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        formatter.locale = NSLocale(localeIdentifier: "en_US")
        return formatter.stringFromNumber(varlor)
    }
}