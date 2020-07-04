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
            InvoiceRepository()
        }
        defaultContainer.register(InvoicesPresenterPresenterProtocol.self) { r in
            InvoicesPresenter(invoiceRepository: r.resolve(InvoiceRepositoryProtocol.self)!)
        }
        defaultContainer.storyboardInitCompleted(InvoicesViewController.self) { r, c in
            c.presenter = r.resolve(InvoicesPresenterPresenterProtocol.self)
        }
    }
}
