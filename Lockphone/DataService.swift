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
    func login(username: String, password: String) -> Observable<CustomerInfo?>{
        return parseHelper.login(username, password: password)
            .flatMap{(user: PFUser?) -> Observable<CustomerInfo?> in
                return self.parserHelper.getCustomerInfo(user)
        }
    }
    func signUp(deviceId: String,nombre: String,direccion: String,telefono: String,ciRuc: String,email: String,password: String)  -> Observable<CustomerInfo?> {
        
        //Sign up user
        return parseHelper.signUp(nombre, direccion: direccion, telefono: telefono, ciRuc: ciRuc, email: email, password: password)
            .flatMap{(user: PFUser?) -> Observable<CustomerInfo?> in
                
                //Asign user to device
                return self.parseHelper.updateDeviceUser(deviceId, user: user)
                    .flatMap{(device: PFObject?) -> Observable<CustomerInfo?> in
                        
                        if let _ = device{
                            debugPrint("Device could not be attached to user")
                        }
                        return self.parserHelper.getCustomerInfo(user)
                        
                    }
            }
    }
}
