//
//  InvoiceMemoryStorage.swift
//  XeroProgrammingExercise
//
//  Created by Tony Mu on 5/07/20.
//  Copyright © 2020 Xero Ltd. All rights reserved.
//

import UIKit

class InvoiceMemoryStorage {
    
    private var data = [Invoice]()
    
    /// Hide Initializer
    private init() {}

    // Swift guarentees that lazily initialized globals or static properties are thread-safe
    static let shared: InvoiceMemoryStorage = {
        let storage = InvoiceMemoryStorage()
        return storage
    }()
    
    func save(invoice: Invoice) {
        if data.contains(invoice) {
            try? update(invoice: invoice)
            return
        }
        add(invoice: invoice)
    }
    
    func get(number: String) -> Invoice? {
        return data.first(where: { $0.number == number })
    }
    
    func get()-> [Invoice] {
        return data
    }
    
    func delete(invoice: Invoice) {
        data.removeAll(where: {$0 == invoice})
    }
    // MARK:- Helper
    
    private func update(invoice: Invoice) throws {
        guard let index = data.firstIndex(of: invoice) else { throw StorageError.noExistingInvoiceFound }
        data[index] = invoice
    }
    
    private func add(invoice: Invoice) {
        data.append(invoice)
    }
    
    enum StorageError: Error {
        case noExistingInvoiceFound
    }
}
