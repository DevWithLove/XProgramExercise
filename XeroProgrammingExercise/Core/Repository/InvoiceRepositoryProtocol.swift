//
//  InvoicesRepositoryProtocol.swift
//  XeroProgrammingExercise
//
//  Created by Tony Mu on 3/07/20.
//  Copyright © 2020 Xero Ltd. All rights reserved.
//

import UIKit

protocol InvoiceRepositoryProtocol {
    func get() -> [Invoice]
}

class InvoiceRepository: InvoiceRepositoryProtocol {
    func get() -> [Invoice] {
        let invoice1 = Invoice(invoiceNumber: "Dev-0001")
        invoice1.addLine(InvoiceLine(invoiceLineId: 1, description: "Banana", quantity: 4, cost: 10.33))
        let invoice2 = Invoice(invoiceNumber: "Dev-0002")
        invoice2.addLine(InvoiceLine(invoiceLineId: 1, description: "Orange", quantity: 1, cost: 5.22))
        invoice2.addLine(InvoiceLine(invoiceLineId: 2, description: "Blueberries", quantity: 3, cost: 6.27))
        let invoice3 = Invoice(invoiceNumber: "Dev-0003")
        invoice3.addLine(InvoiceLine(invoiceLineId: 1, description: "Pizza", quantity: 1, cost: 9.99))
        return [invoice1, invoice2, invoice3]
    }
}
