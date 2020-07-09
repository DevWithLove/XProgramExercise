//
//  DateTests.swift
//  XeroProgrammingExerciseTests
//
//  Created by Tony Mu on 9/07/20.
//  Copyright © 2020 Xero Ltd. All rights reserved.
//

import XCTest
@testable import XeroProgrammingExercise

class DateTests: XCTestCase {


    func testCreate_local_date() {
        // Arrange
        let date = Date.getDate(year: 2020, month: 07, day: 05, hour: 13, minute: 25)!
    
        // Act
        let dateInString = date.toString(dateFormat: "dd/MM/YYY HH:mm")
        
        // Assert
        XCTAssertEqual(dateInString, "05/07/2020 13:25")
    }
}
