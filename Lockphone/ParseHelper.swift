//
//  ParseHelper.swift
//  Lockphone
//
//  Created by Daniel Coellar on 12/30/15.
//  Copyright © 2015 lockphone. All rights reserved.
//

import Foundation
import Parse
import RxSwift

enum PFObjects: String {
    case Brands
    case Devices
}

class ParseHelper {
    
    //Brands
    func getBrand(brand: String, model: String) -> Observable<PFObject?>{
        return create { observer in
            let query = PFQuery(className: PFObjects.Brands.rawValue)
            query.whereKey("brand", equalTo: brand)
            query.whereKey("model", equalTo: model)
            query.getFirstObjectInBackgroundWithBlock { (object: PFObject?, error: NSError?) -> Void in
                if error == nil && object != nil {
                    observer.on(.Next(object))
                    observer.on(.Completed)
                } else {
                    observer.on(.Next(nil))
                    observer.on(.Completed)
                }
            }
            return NopDisposable.instance
        }
    }
    
    //Devices
    func getDevice(deviceId: String) -> Observable<PFObject?>{
        return create { observer in
            let query = PFQuery(className:PFObjects.Devices.rawValue)
            query.includeKey("brand")
            query.getObjectInBackgroundWithId(deviceId) { (device: PFObject?, error: NSError?) -> Void in
                if error == nil && device != nil {
                    observer.on(.Next(device))
                    observer.on(.Completed)
                } else {
                    observer.on(.Next(nil))
                    observer.on(.Completed)
                }
            }
            return NopDisposable.instance
        }
    }
    func getDeviceWithImei(imei: String) -> Observable<PFObject?>{
        return create { observer in
            let query = PFQuery(className:PFObjects.Devices.rawValue)
            query.includeKey("brand")
            query.whereKey("imei",equalTo: imei)
            query.getFirstObjectInBackgroundWithBlock({ (device: PFObject?, error: NSError?) -> Void in
                if error == nil && device != nil {
                    observer.on(.Next(device))
                    observer.on(.Completed)
                } else {
                    observer.on(.Next(nil))
                    observer.on(.Completed)
                }
            })
            return NopDisposable.instance
        }
    }
    func createDevice(brand: PFObject?) -> Observable<PFObject?>{
        return create { observer in
            let device = PFObject(className:PFObjects.Devices.rawValue)
            device.setValue(brand, forKey: "brand")
            device.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                if (success) {
                    observer.on(.Next(device))
                    observer.on(.Completed)
                } else {
                    observer.on(.Next(nil))
                    observer.on(.Completed)
                }
            }
            return NopDisposable.instance
        }
    }
    func updateDeviceUser(deviceId: String, user: PFUser?) -> Observable<PFObject?>{
        return create { observer in
            self.getDevice(deviceId).subscribeNext({ (object: PFObject?) -> Void in
                if let device = object{
                    device.setValue(user, forKey: "user")
                    device.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                        if (success) {
                            observer.on(.Next(device))
                            observer.on(.Completed)
                        } else {
                            observer.on(.Next(nil))
                            observer.on(.Completed)
                        }
                    }
                }else{
                    observer.on(.Next(nil))
                    observer.on(.Completed)
                }
            })
            return NopDisposable.instance
        }
    }
    
    //User
    func login(username: String, password: String) -> Observable<PFUser?>{
        return create { observer in
            PFUser.logInWithUsernameInBackground(username, password: password, block: { (user:PFUser?, error: NSError?) -> Void in
                if user != nil {
                    observer.on(.Next(user))
                    observer.on(.Completed)
                } else {
                    observer.on(.Next(nil))
                    observer.on(.Completed)
                }
            })
            return NopDisposable.instance
        }
    }
    func signUp(nombre: String,direccion: String,telefono: String,ciRuc: String,email: String,password: String)  -> Observable<PFUser?> {
        return create { observer in
            let user = PFUser()
            user.username = email
            user.password = password
            user.email = email
            user["nombre"] = nombre
            user["direccion"] = direccion
            user["telefono"] = telefono
            user["ci_ruc"] = ciRuc
        
            user.signUpInBackgroundWithBlock {
                (succeeded: Bool, error: NSError?) -> Void in
                if let error = error {
                    debugPrint(error.userInfo["error"] as? NSString)
                    observer.on(.Next(nil))
                    observer.on(.Completed)
                } else {
                    observer.on(.Next(user))
                    observer.on(.Completed)
                }
            }
            return NopDisposable.instance
        }
    }
}