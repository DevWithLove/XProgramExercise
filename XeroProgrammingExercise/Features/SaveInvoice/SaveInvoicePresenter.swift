//
//  SafeInvoicePresenter.swift
//  XeroProgrammingExercise
//
//  Created by Tony Mu on 5/07/20.
//  Copyright © 2020 Xero Ltd. All rights reserved.
//

import UIKit


protocol SaveInvoiceViewProtocol: class {
    func invoiceIsSaved()
}

protocol SaveInvoicePresenterProtocol {
    var viewDelegate: SaveInvoiceViewProtocol? { get set }
    func save(invoice: Invoice)
}

class SaveInvoicePresenter: SaveInvoicePresenterProtocol {
 
    private let invoiceRepository: InvoiceRepositoryProtocol
    weak var viewDelegate: SaveInvoiceViewProtocol?
    
    init(invoiceRepository: InvoiceRepositoryProtocol) {
        self.invoiceRepository = invoiceRepository
    }

    func save(invoice: Invoice) {
        invoiceRepository.save(invoice: invoice)
        viewDelegate?.invoiceIsSaved()
    }
}
