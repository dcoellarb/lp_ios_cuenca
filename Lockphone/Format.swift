//
//  Format.swift
//  Lockphone
//
//  Created by Daniel Coellar on 1/25/16.
//  Copyright © 2016 lockphone. All rights reserved.
//

import Foundation

class Format {
    func formatCurrency(varlor: Double) -> String? {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        formatter.locale = NSLocale(localeIdentifier: "en_US")
        return formatter.stringFromNumber(varlor)
    }
}