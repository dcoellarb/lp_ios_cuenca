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
            STPAPIClient.sharedClient().createTokenWithCard(card) { (token, error) -> Void in
                if let token = token {
                    observer.on(.Next(true))
                    self.createBackendChargeWithToken(token) { (status, error) -> Void in
                        if status == PKPaymentAuthorizationStatus.Success{
                            observer.on(.Next(true))
                            //TODO call create contract and send email service
                            observer.on(.Completed)
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
        //TODO check internet conexion
        let parameters = [
            "stripeToken": token.tokenId,
            "plan": "lockphone_iphone",
            "email" : "dcoellar@gmail.com"
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
    }
    
}