//
//  PaymentViewModel.swift
//  Lockphone
//
//  Created by Daniel Coellar on 1/18/16.
//  Copyright © 2016 lockphone. All rights reserved.
//

import Foundation
import Stripe
import Alamofire
import SwiftyJSON
import RxSwift

class PaymentViewModel {
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    //Paypal
    let payPalConfiguration = PayPalConfiguration()

    init() {
        //Paypal
        payPalConfiguration.merchantName = "lockphone"
        payPalConfiguration.merchantPrivacyPolicyURL = NSURL(string: "https://www.omega.supreme.example/privacy")
        payPalConfiguration.merchantUserAgreementURL = NSURL(string: "https://www.omega.supreme.example/user_agreement")
    }
    
    //Paypal
    func preconnectToPayPalService() {
        // Start out working with the mock environment. When you are ready, switch to PayPalEnvironmentProduction.
        PayPalMobile.preconnectWithEnvironment(PayPalEnvironmentNoNetwork)
    }
    
    //Stripe
    func subscripbeForPayments(card: STPCardParams) -> Observable<Bool> {
        return create { observer in
            //Create token
            STPAPIClient.sharedClient().createTokenWithCard(card) { (token, error) -> Void in
                if let token = token {
                    observer.on(.Next(true))
                    //Create Strip subscription
                    self.createBackendChargeWithToken(token) { (status, error) -> Void in
                        if status == PKPaymentAuthorizationStatus.Success{
                            observer.on(.Next(true))
                            
                            //Marc phone as insured from now on
                            self.defaults.setBool(true, forKey: UserDefatulsKeys.localPhoneInsured)
                            
                            //Create contract and send email
                            self.createContract{ (success, error) -> Void in
                                if success {
                                    observer.on(.Next(true))
                                    observer.on(.Completed)
                                } else {
                                    var resultError = NSError(domain: "LockphoneAPIError", code: 0, userInfo: ["code":0,"error":"Undefined Lockphone API Error"])
                                    if let e = error {
                                        resultError = e
                                    }
                                    observer.on(.Error(resultError))
                                    observer.on(.Completed)
                                }
                            }
                            
                        }else{
                            var resultError = NSError(domain: "StripeError", code: 0, userInfo: ["code":0,"error":"Undefined Error"])
                            if let e = error {
                                resultError = e
                            }
                            observer.on(.Error(resultError))
                            observer.on(.Completed)
                        }
                    }
                } else {
                    var resultError = NSError(domain: "StripeError", code: 0, userInfo: ["code":0,"error":"Undefined Error"])
                    if let e = error {
                        resultError = e
                    }
                    observer.on(.Error(resultError))
                    observer.on(.Completed)
                }
            }
            return NopDisposable.instance
        }
    }
    func createBackendChargeWithToken(token: STPToken, completion: (PKPaymentAuthorizationStatus,NSError?) -> ()) {
        if let email = defaults.objectForKey(UserDefatulsKeys.localEmail) as? String {
            //TODO check internet conexion
            let parameters = [
                "stripeToken": token.tokenId,
                "plan": "lockphone_iphone",
                "email" : email
            ]
            Alamofire.request(.POST, "https://lockphone-qa-najhp5-2388.herokuapp.com/api/payments/subscriptions/customers", parameters: parameters, encoding: .JSON)
                .responseJSON { response in
                
                    var resultStatus = PKPaymentAuthorizationStatus.Failure
                    var resultError : NSError? = NSError(domain: "LockphoneAPIError",code: 0, userInfo: ["code":0,"error":"Undefined Lockphone API Error"])

                    switch response.result {
                    case .Success:
                        if let data = response.data{
                            let json = JSON(data: data)
                            if json["error"] != nil {
                                //TODO create NSError from json
                                resultError = nil
                            } else {
                                resultStatus = PKPaymentAuthorizationStatus.Success
                                resultError = nil
                            }
                        }
                    case .Failure(let error):
                        resultError = error
                    }
                    completion(resultStatus,resultError)
            }
        } else {
            completion(PKPaymentAuthorizationStatus.Failure,NSError(domain: "LockphoneAPIError",code: 0, userInfo: ["code":0,"error":"local parameters are not setup"]))
        }
    }
    
    //Helper Methods
    func createContract(completion: (Bool,NSError?) -> ()){
        if let deviceId = defaults.objectForKey(UserDefatulsKeys.localDeviceId) as? String,
            let nombre = defaults.objectForKey(UserDefatulsKeys.localNombre) as? String,
            let email = defaults.objectForKey(UserDefatulsKeys.localEmail) as? String {
        
            //TODO check internet conexion
            let parameters = [
                "deviceId": deviceId,
                "nombre": nombre,
                "email": email
            ]
            Alamofire.request(.POST, "https://lockphone-qa-najhp5-2388.herokuapp.com/api/customers/contracts", parameters: parameters, encoding: .JSON)
                .responseJSON { response in
            
                var resultStatus = false
                var resultError : NSError? = NSError(domain: "LockphoneAPIError",code: 0, userInfo: ["code":0,"error":"Undefined Lockphone API Error"])
                switch response.result {
                case .Success:
                    if let data = response.data{
                        let json = JSON(data: data)
                        if json["error"] != nil {
                            //TODO create NSError from json
                            resultError = nil
                        } else {
                            resultStatus = true
                            resultError = nil
                        }
                    }
                    case .Failure(let error):
                        resultError = error
                }
                completion(resultStatus,resultError)
            }
        } else {
            completion(false,NSError(domain: "LockphoneAPIError",code: 0, userInfo: ["code":0,"error":"local parameters are not setup"]))
        }
    }
}