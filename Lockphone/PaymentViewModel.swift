//
//  PaymentViewModel.swift
//  Lockphone
//
//  Created by Daniel Coellar on 1/18/16.
//  Copyright © 2016 lockphone. All rights reserved.
//

import Foundation

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
    
}