//
//  CustomerInfoViewModel.swift
//  Lockphone
//
//  Created by Daniel Coellar on 1/14/16.
//  Copyright © 2016 lockphone. All rights reserved.
//

import Foundation
import RxSwift

class CustomerInfoViewModel {

    private var customerInfo = CustomerInfo()
    
    var nombre: String {
        get {
            return customerInfo.nombre
        }
        set(value) {
            customerInfo.nombre = value
        }
    }
    var direccion: String {
        get {
            return customerInfo.direccion
        }
        set(value) {
            customerInfo.direccion = value
        }
    }
    var telefono: String {
        get {
            return customerInfo.telefono
        }
        set(value) {
            customerInfo.telefono = value
        }
    }
    var rucCI: String {
        get {
            return customerInfo.rucCI
        }
        set(value) {
            customerInfo.rucCI = value
        }
    }
    var email: String {
        get {
            return customerInfo.email
        }
        set(value) {
            customerInfo.email = value
        }
    }
    var password: String {
        get {
            return customerInfo.password
        }
        set(value) {
            customerInfo.password = value
        }
    }
    var confirmPassword = ""
    var loginUsername = ""
    var loginPassword = ""
    
    func validateEmail() ->  Bool{
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(self.email)
    }
    
    func validatePassword() -> Bool{
        if self.password == self.confirmPassword {
            return true
        } else {
            return false
        }
    }

    func validateForm() -> Bool{
        if self.nombre.isEmpty || self.direccion.isEmpty || self.telefono.isEmpty || self.rucCI.isEmpty || self.email.isEmpty || self.password.isEmpty {
            return false
        } else {
            return true
        }
    }
    
    func validateLoginForm() -> Bool{
        if self.loginUsername.isEmpty || self.loginPassword.isEmpty {
            return false
        } else {
            return true
        }
    }
    
    
    //User
    func login() -> Observable<Bool>{
        return DataService.sharedInstance.login(self.loginUsername,password: self.loginPassword)
            .flatMap{(customerInfo: CustomerInfo?) -> Observable<Bool> in
                return create { observer in
                    if let _ = customerInfo {
                        
                        let defaults = NSUserDefaults.standardUserDefaults()
                        defaults.setValue(customerInfo?.nombre, forKey: UserDefatulsKeys.localNombre)
                        defaults.setValue(customerInfo?.direccion, forKey: UserDefatulsKeys.localDireccion)
                        defaults.setValue(customerInfo?.telefono, forKey: UserDefatulsKeys.localTelefono)
                        defaults.setValue(customerInfo?.rucCI, forKey: UserDefatulsKeys.localRucCI)
                        defaults.setValue(customerInfo?.email, forKey: UserDefatulsKeys.localEmail)
                        
                        observer.on(.Next(true))
                        observer.on(.Completed)
                    }else{
                        observer.on(.Next(false))
                        observer.on(.Completed)
                    }
                    
                    return NopDisposable.instance
                }
            }
    }
    func signUp()  -> Observable<Bool> {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let deviceId = defaults.objectForKey(UserDefatulsKeys.localDeviceId) as? String {
            return DataService.sharedInstance.signUp(deviceId,nombre: self.nombre, direccion: self.direccion, telefono: self.telefono, ciRuc: self.rucCI, email: self.email, password: self.password)
                .flatMap{(customerInfo: CustomerInfo?) -> Observable<Bool> in
                    return create { observer in
                        if let _ = customerInfo {
                            
                            let defaults = NSUserDefaults.standardUserDefaults()
                            defaults.setValue(customerInfo?.nombre, forKey: UserDefatulsKeys.localNombre)
                            defaults.setValue(customerInfo?.direccion, forKey: UserDefatulsKeys.localDireccion)
                            defaults.setValue(customerInfo?.telefono, forKey: UserDefatulsKeys.localTelefono)
                            defaults.setValue(customerInfo?.rucCI, forKey: UserDefatulsKeys.localRucCI)
                            defaults.setValue(customerInfo?.email, forKey: UserDefatulsKeys.localEmail)
                                                        
                            observer.on(.Next(true))
                            observer.on(.Completed)
                        }else{
                            observer.on(.Next(false))
                            observer.on(.Completed)
                        }
                        return NopDisposable.instance
                    }
            }
        }else{
            return create { observer in
                observer.on(.Next(false))
                observer.on(.Completed)
                return NopDisposable.instance
            }
        }
    }
}