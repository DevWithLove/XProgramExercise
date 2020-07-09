//
//  DateExtensions.swift
//  XeroProgrammingExercise
//
//  Created by Tony Mu on 3/07/20.
//  Copyright © 2020 Xero Ltd. All rights reserved.
//

import Foundation

extension Date {
    
    /// Convert date to string in format
    func toString(dateFormat format: String)-> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    static func getDate(year:Int, month: Int, day: Int, hour: Int, minute: Int) -> Date? {
        var dateComponent = DateComponents()
        dateComponent.year = year
        dateComponent.month = month
        dateComponent.day = day
        dateComponent.timeZone = Calendar.current.timeZone
        dateComponent.hour = hour
        dateComponent.minute = minute
        return Calendar.current.date(from: dateComponent)
    }
}
