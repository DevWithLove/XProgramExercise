//
//  InvoicesPresenter.swift
//  XeroProgrammingExercise
//
//  Created by Tony Mu on 3/07/20.
//  Copyright © 2020 Xero Ltd. All rights reserved.
//

protocol InvoicesViewProtocol: class {
    func presentInvoices(_ invoices: [Invoice])
    func presentInvoiceDeleted(invoice: Invoice)
}

protocol InvoicesPresenterPresenterProtocol {
    var viewDelegate: InvoicesViewProtocol? { get set }
    func loadInvoices()
    func save(invoice: Invoice)
    func deleteInvoice(invoice: Invoice)
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
//        let service = InvoiceService()
//        service.get { [weak self] (result) in
//            switch result {
//            case .success(let invoices):
//                self?.viewDelegate?.presentInvoices(invoices)
//            case .failure(let error):
//                print("Error: \(error)")
//            }
//        }
    }
    
    func save(invoice: Invoice) {
        invoiceRepository.save(invoice: invoice)
    }
    
    func deleteInvoice(invoice: Invoice) {
        guard let delegate = viewDelegate else { return }
        invoiceRepository.delete(invoice: invoice)
        delegate.presentInvoiceDeleted(invoice: invoice)
    }
}
