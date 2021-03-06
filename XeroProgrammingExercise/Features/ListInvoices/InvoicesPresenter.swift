//
//  InvoicesPresenter.swift
//  XeroProgrammingExercise
//
//  Created by Tony Mu on 3/07/20.
//  Copyright © 2020 Xero Ltd. All rights reserved.
//

protocol InvoicesViewProtocol: class {
    func presentInvoices(_ invoices: [Invoice])
}

protocol InvoicesPresenterPresenterProtocol {
    var viewDelegate: InvoicesViewProtocol? { get set }
    func loadInvoices()
}

class InvoicesPresenter: InvoicesPresenterPresenterProtocol {
    
    private let invoiceRepository: InvoiceRepositoryProtocol
    
    weak var viewDelegate: InvoicesViewProtocol?
    
    init(invoiceRepository: InvoiceRepositoryProtocol) {
        self.invoiceRepository = invoiceRepository
    }
    
    func loadInvoices() {
        // Business logic here
        guard let view = viewDelegate else { return }
        let invoices = invoiceRepository.get()
        view.presentInvoices(invoices)
    }
}
