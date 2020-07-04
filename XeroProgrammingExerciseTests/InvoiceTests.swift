//
//  InvoiceTests.swift
//  XeroProgrammingExerciseTests
//
//  Created by Tony Mu on 3/07/20.
//  Copyright © 2020 Xero Ltd. All rights reserved.
//

import XCTest
@testable import XeroProgrammingExercise

class InvoiceTests: XCTestCase {

    func testInvoice_addLine() {
        // Arrange
        let invoice = Invoice(invoiceNumber: "Dev-0001")
        
        // Act
        invoice.addLine(InvoiceLine(invoiceLineId: 1, description: "Banana", quantity: 4, cost: 10.21))
        invoice.addLine(InvoiceLine(invoiceLineId: 2, description: "Orange", quantity: 1, cost: 5.21))
        invoice.addLine(InvoiceLine(invoiceLineId: 3, description: "Pizza", quantity: 5, cost: 5.21))

        // Assert
        XCTAssertEqual(invoice.numberOfLines, 3)
        XCTAssertEqual(invoice.total.currencyValue, Decimal(72.1).currencyValue)
        XCTAssertEqual(invoice[0].invoiceLineId, 1)
        XCTAssertEqual(invoice[0].description, "Banana")
        XCTAssertEqual(invoice[1].invoiceLineId, 2)
        XCTAssertEqual(invoice[1].description, "Orange")
        XCTAssertEqual(invoice[2].invoiceLineId, 3)
        XCTAssertEqual(invoice[2].description, "Pizza")
        
    }
    
    func testInvoice_removeLine_by_id() {
        // Arrange
        let invoice = Invoice(invoiceNumber: "Dev-0001")
        
        // Act
        invoice.addLine(InvoiceLine(invoiceLineId: 1, description: "Orange", quantity: 1, cost: 5.22))
        invoice.addLine(InvoiceLine(invoiceLineId: 2, description: "Banana", quantity: 4, cost: 10.33))
        invoice.removeLine(lineId: 1)
        
        // Assert
        XCTAssertEqual(invoice.numberOfLines, 1)
        XCTAssertEqual(invoice.total.currencyValue, Decimal(41.32).currencyValue)
        XCTAssertEqual(invoice[0].invoiceLineId, 2)
        XCTAssertEqual(invoice[0].description, "Banana")
    }
    
    func testInvoice_removeLine_by_no_existing_id() {
        // Arrange
        let invoice = Invoice(invoiceNumber: "Dev-0001")
        
        // Act
        invoice.addLine(InvoiceLine(invoiceLineId: 1, description: "Orange", quantity: 1, cost: 5.22))
        invoice.addLine(InvoiceLine(invoiceLineId: 2, description: "Banana", quantity: 4, cost: 10.33))
        invoice.removeLine(lineId: 5)
        
        // Assert
        XCTAssertEqual(invoice.numberOfLines, 2)
    }
    
    func testInvoice_mergeInvoices() {
        // Arrange
        let invoiceOne = Invoice(invoiceNumber: "Dev-0001")
        let invoiceTwo = Invoice(invoiceNumber: "Dev-0002")
        
        // Act
        invoiceOne.addLine(InvoiceLine(invoiceLineId: 1, description: "Banana", quantity: 4, cost: 10.33))
        invoiceTwo.addLine(InvoiceLine(invoiceLineId: 2, description: "Orange", quantity: 1, cost: 5.22))
        invoiceTwo.addLine(InvoiceLine(invoiceLineId: 3, description: "Blueberries", quantity: 3, cost: 6.27))
        
        invoiceOne.merge(sourceInvoice: invoiceTwo)
        
        // Assert
        XCTAssertEqual(invoiceOne.numberOfLines, 3)
        XCTAssertEqual(invoiceOne.total.currencyValue, Decimal(65.35).currencyValue)
        XCTAssertEqual(invoiceOne[0].invoiceLineId, 1)
        XCTAssertEqual(invoiceOne[0].description, "Banana")
        XCTAssertEqual(invoiceOne[1].invoiceLineId, 2)
        XCTAssertEqual(invoiceOne[1].description, "Orange")
        XCTAssertEqual(invoiceOne[2].invoiceLineId, 3)
        XCTAssertEqual(invoiceOne[2].description, "Blueberries")
    }
    
    func testInvoice_clone() {
        // Arrange
        let invoice = Invoice(invoiceNumber: "Dev-0001")
        
        // Act
        invoice.addLine(InvoiceLine(invoiceLineId: 1, description: "Apple", quantity: 1, cost: 6.99))
        invoice.addLine(InvoiceLine(invoiceLineId: 2, description: "Blueberries", quantity: 3, cost: 6.27))
        
        let invoiceCopy = invoice.clone()
        invoiceCopy.number = "Dev-0002"
        invoiceCopy.addLine(InvoiceLine(invoiceLineId: 3, description: "Orange", quantity: 1, cost: 5.22))
        
        // Assert
        XCTAssertEqual(invoice.number, "Dev-0001")
        XCTAssertEqual(invoice.numberOfLines, 2)
        
        XCTAssertEqual(invoiceCopy.number, "Dev-0002")
        XCTAssertEqual(invoiceCopy.numberOfLines, 3)
    }
    
    func testInvoice_oderLineItems() {
        // Arrange
        let invoice = Invoice(invoiceNumber: "Dev-0001")
        
        // Act
        invoice.addLine(InvoiceLine(invoiceLineId: 3, description: "Banana", quantity: 4, cost: 10.21))
        invoice.addLine(InvoiceLine(invoiceLineId: 2, description: "Orange", quantity: 1, cost: 5.21))
        invoice.addLine(InvoiceLine(invoiceLineId: 1, description: "Pizza", quantity: 5, cost: 5.21))
        
        invoice.oderLineItems()
        
        // Assert
        XCTAssertEqual(invoice[0].invoiceLineId, 1)
        XCTAssertEqual(invoice[0].description, "Pizza")
        XCTAssertEqual(invoice[1].invoiceLineId, 2)
        XCTAssertEqual(invoice[1].description, "Orange")
        XCTAssertEqual(invoice[2].invoiceLineId, 3)
        XCTAssertEqual(invoice[2].description, "Banana")
    }
    
    func testInvoice_removeitems_from_anotherInvoice() {
        // Arrange
        let invoiceOne = Invoice(invoiceNumber: "Dev-0001")
        let invoiceTwo = Invoice(invoiceNumber: "Dev-0002")
        
        // Act
        
        invoiceOne.addLine(InvoiceLine(invoiceLineId: 1, description: "Banana", quantity: 4, cost: 10.33))
        invoiceOne.addLine(InvoiceLine(invoiceLineId: 3, description: "Blueberries", quantity: 3, cost: 6.27))
        invoiceTwo.addLine(InvoiceLine(invoiceLineId: 2, description: "Orange", quantity: 1, cost: 5.22))
        invoiceTwo.addLine(InvoiceLine(invoiceLineId: 3, description: "Blueberries", quantity: 3, cost: 6.27))
        
        invoiceOne.removeItems(from: invoiceTwo)
        
        // Assert
        XCTAssertEqual(invoiceOne.numberOfLines, 1)
        XCTAssertEqual(invoiceOne.total.currencyValue, Decimal(41.32).currencyValue)
        XCTAssertEqual(invoiceOne[0].invoiceLineId, 1)
        XCTAssertEqual(invoiceOne[0].description, "Banana")
    }
    
    func testInvoice_removeitems_from_anotherInvoice_allmatch() {
        // Arrange
        let invoiceOne = Invoice(invoiceNumber: "Dev-0001")
        let invoiceTwo = Invoice(invoiceNumber: "Dev-0002")
        
        // Act
        invoiceOne.addLine(InvoiceLine(invoiceLineId: 1, description: "Banana", quantity: 4, cost: 10.33))
        invoiceOne.addLine(InvoiceLine(invoiceLineId: 3, description: "Blueberries", quantity: 3, cost: 6.27))
        invoiceTwo.addLine(InvoiceLine(invoiceLineId: 1, description: "Banana", quantity: 4, cost: 10.33))
        invoiceTwo.addLine(InvoiceLine(invoiceLineId: 3, description: "Blueberries", quantity: 3, cost: 6.27))
        
        invoiceOne.removeItems(from: invoiceTwo)
        
        // Assert
        XCTAssertEqual(invoiceOne.numberOfLines, 0)
    }
    
    func testInvoice_previewLineItems() {
        // Arrange
        let invoice = Invoice(invoiceNumber: "Dev-0001")
        
        // Act
        invoice.addLine(InvoiceLine(invoiceLineId: 1, description: "Line 1", quantity: 1, cost: 22.5))
        invoice.addLine(InvoiceLine(invoiceLineId: 2, description: "Line 2", quantity: 1, cost: 20.0))
        invoice.addLine(InvoiceLine(invoiceLineId: 3, description: "Line 3", quantity: 1, cost: 22.5))
        invoice.addLine(InvoiceLine(invoiceLineId: 4, description: "Line 4", quantity: 1, cost: 20.0))
        
        let previewlinesOne = invoice.previewLineItems(2)
        let previewLinesTwo = invoice.previewLineItems(10)
        
        // Assert
        XCTAssertEqual(previewlinesOne.count, 2)
        XCTAssertEqual(previewLinesTwo.count, 4)
    }
}
