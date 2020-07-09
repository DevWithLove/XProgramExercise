//
//  InvoiceServiceProtocol.swift
//  XeroProgrammingExercise
//
//  Created by Tony Mu on 9/07/20.
//  Copyright © 2020 Xero Ltd. All rights reserved.
//

import UIKit

protocol InvoiceServiceProtocol {
    func get(completion: @escaping (Result<[Invoice], Error>)-> Void )
}

class InvoiceService: InvoiceServiceProtocol {
    func get(completion: @escaping (Result<[Invoice], Error>)-> Void ) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            completion(.success([
                Invoice(invoiceNumber: "Online-01"),
                Invoice(invoiceNumber: "Online-02")
            ]))
        }
    }
}
