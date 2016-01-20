//
//  DataService.swift
//  Lockphone
//
//  Created by Daniel Coellar on 12/30/15.
//  Copyright © 2015 lockphone. All rights reserved.
//

import Foundation
import Parse
import RxSwift

class DataService {
    
    static let sharedInstance = DataService()

    let parseHelper = ParseHelper()
    let parserHelper = ParserHelper()
    
    //Device
    func getDevice(deviceId: String) -> Observable<PhoneInfoModel> {
        return parseHelper.getDevice(deviceId)
            .flatMap{(device: PFObject?) -> Observable<PhoneInfoModel> in
                return self.parserHelper.getPhoneInfo(device)
            }
    }
    func getDeviceWithImei(imei: String) -> Observable<PhoneInfoModel> {
        return parseHelper.getDeviceWithImei(imei)
            .flatMap{(device: PFObject?) -> Observable<PhoneInfoModel> in
                return self.parserHelper.getPhoneInfo(device)
        }
    }
    func createDevice() -> Observable<PhoneInfoModel> {
        let model = DeviceModel.sharedInstance.modelName

        return parseHelper.getBrand("Apple", model: model)
            .flatMap{ (brand: PFObject?) -> Observable<PhoneInfoModel> in
        
                return self.parseHelper.createDevice(brand)
                    .flatMap{(device: PFObject?) -> Observable<PhoneInfoModel> in
                
                        return self.parserHelper.getPhoneInfo(device)
                        
                }
        }
    }
    
    //User
    func login(username: String, password: String) -> Observable<String?>{
        return parseHelper.login(username, password: password)
            .flatMap{(user: PFUser?) -> Observable<String?> in
                return create { observer in
                    observer.on(.Next(user?.objectId))
                    observer.on(.Completed)
                    return NopDisposable.instance
                }
        }
    }
    func signUp(deviceId: String,nombre: String,direccion: String,telefono: String,ciRuc: String,email: String,password: String)  -> Observable<String?> {
        
        //Sign up user
        return parseHelper.signUp(nombre, direccion: direccion, telefono: telefono, ciRuc: ciRuc, email: email, password: password)
            .flatMap{(user: PFUser?) -> Observable<String?> in
                return create { observer in
                    
                    //Attach device to user
                    self.parseHelper.updateDeviceUser(deviceId, user: user).subscribeNext({ (device: PFObject?) -> Void in
                        if let _ = device{
                            debugPrint("Device could not be attached to user")
                        }
                        observer.on(.Next(user?.objectId))
                        observer.on(.Completed)
                    })
                    
                    return NopDisposable.instance
                }
        }
    }
}
