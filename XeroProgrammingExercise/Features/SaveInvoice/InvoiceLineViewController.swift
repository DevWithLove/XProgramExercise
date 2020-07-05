//
//  InvoiceLineViewController.swift
//  XeroProgrammingExercise
//
//  Created by Tony Mu on 5/07/20.
//  Copyright © 2020 Xero Ltd. All rights reserved.
//

import UIKit

protocol InviceLineViewDelegate: class {
    func savedLine(line: InvoiceLine)
}

class InvoiceLineViewController: UIViewController {
    
    // MARK:- Constants
    private let kSpacing: CGFloat = 10
    
    // MARK:- Properties
    
    var invoiceLine: InvoiceLine? {
        didSet {
            descriptionInputView.text = invoiceLine?.description
            quantityInputView.text = invoiceLine?.quantity.description
            costInputView.text = invoiceLine?.cost.description
        }
    }
    weak var delegate: InviceLineViewDelegate?
    
    // MARK: - Views
    
    private lazy var descriptionInputView: UITextField = {
        let view = UITextField()
        view.placeholder = "Description"
        return view
    }()
    
    private lazy var quantityInputView: UITextField = {
        let view = UITextField()
        view.placeholder = "Quantity"
        view.keyboardType = .numberPad
        return view
    }()
    
    private lazy var costInputView: UITextField = {
        let view = UITextField()
        view.placeholder = "Coast"
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [descriptionInputView,quantityInputView,costInputView])
        view.axis = .vertical
        view.spacing = kSpacing
        return view
    }()
    
    private lazy var rightBarItem: UIBarButtonItem = {
        let item = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(addLine))
        return item
    }()
    
    // MARK:- iOS Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK:- Helpers
    
    @objc func addLine() {
        guard let lineId = invoiceLine?.invoiceLineId,
              let lineDescription = descriptionInputView.text,
              let lineQuantity = UInt(quantityInputView.text ?? ""),
              let lineCost = Decimal(string: costInputView.text ?? "")  else { return }
        
        let line = InvoiceLine(invoiceLineId: lineId, description: lineDescription, quantity: lineQuantity, cost: lineCost)
        delegate?.savedLine(line: line)
        navigationController?.popViewController(animated: true)
    }
    
    private func setupUI() {
        navigationItem.rightBarButtonItem = rightBarItem
        view.backgroundColor = .systemBackground
        view.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
    }
}
