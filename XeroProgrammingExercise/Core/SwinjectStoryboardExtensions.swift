//
//  SwinjectStoryboardExtensions.swift
//  XeroProgrammingExercise
//
//  Created by Tony Mu on 3/07/20.
//  Copyright © 2020 Xero Ltd. All rights reserved.
//

import Swinject
import SwinjectStoryboard

extension SwinjectStoryboard {
    @objc class func setup() {
        defaultContainer.register(InvoiceRepositoryProtocol.self) { _ in
            RealmStorage()
           // InvoiceRepository()
        }
        defaultContainer.register(InvoicesPresenterPresenterProtocol.self) { r in
            InvoicesPresenter(invoiceRepository: r.resolve(InvoiceRepositoryProtocol.self)!)
        }
        defaultContainer.storyboardInitCompleted(InvoicesViewController.self) { r, c in
            c.presenter = r.resolve(InvoicesPresenterPresenterProtocol.self)
            c.container = defaultContainer
        }
        // Save Inovice
        defaultContainer.register(SaveInvoicePresenterProtocol.self) { r in
            SaveInvoicePresenter(invoiceRepository: r.resolve(InvoiceRepositoryProtocol.self)!)
        }
        defaultContainer.register(SaveInvoiceViewController.self) { r in
            let vc = SaveInvoiceViewController()
            vc.presenter = r.resolve(SaveInvoicePresenterProtocol.self)
            vc.container = defaultContainer
            return vc
        }
        defaultContainer.register(InvoiceLineViewController.self) { r in
            return InvoiceLineViewController()
        }
    }
}
