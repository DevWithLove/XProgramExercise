//
//  Decimal+.swift
//  XeroProgrammingExercise
//
//  Created by Tony Mu on 3/07/20.
//  Copyright © 2020 Xero Ltd. All rights reserved.
//
import Foundation

extension Decimal {
    
    /// Convert decimal to a string in local currency
    var currencyValue: String {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        return formatter.string(from: self as NSNumber) ?? ""
    }
    
    /// convert to Double
    var doubleValue: Double {
        return NSDecimalNumber(decimal:self).doubleValue
    }
    
}
