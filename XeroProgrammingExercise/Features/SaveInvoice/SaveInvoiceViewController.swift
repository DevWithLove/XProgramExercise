//
//  AddInvoiceViewController.swift
//  XeroProgrammingExercise
//
//  Created by Tony Mu on 5/07/20.
//  Copyright © 2020 Xero Ltd. All rights reserved.
//

import UIKit
import Swinject

class SaveInvoiceViewController: UIViewController {
    
    // MARK: - Properties
    
    var invoiceNumber: String? {
        didSet {
            invoiceNumberInputView.text = invoiceNumber
        }
    }
    var invoiceLines = [InvoiceLine]()
    var presenter: SaveInvoicePresenterProtocol?
    var container: Container!
    
    // MARK:- View
    
    private lazy var invoiceNumberInputView: UITextField = {
        let inputView = UITextField()
        inputView.placeholder = "Invoice number"
        return inputView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "simplecell")
        return tableView
    }()

    private lazy var addLineBarItem: UIBarButtonItem = {
        let barItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addInvoiceLine))
        return barItem
    }()
    
    private lazy var saveInvoiceBarItem: UIBarButtonItem = {
        let barItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveInvice))
        return barItem
    }()
    
    // MARK:- iOS Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        presenter?.viewDelegate = self
        setupUI()
    }
    
    // MARK:- Helper
    
    private func setupUI() {
        navigationItem.rightBarButtonItems = [saveInvoiceBarItem, addLineBarItem]
        view.addSubview(invoiceNumberInputView)
        view.addSubview(tableView)
        buildConstraints()
    }
    
    private func buildConstraints() {
        invoiceNumberInputView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalTo(tableView.snp.top).offset(-20)
        }
        tableView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    @objc func addInvoiceLine() {
        let lineId = invoiceLines.last == nil ? 1 : invoiceLines.count + 1
        let line = InvoiceLine(invoiceLineId: lineId, description: "", quantity: 0, cost: 0)
        navigateToInvocieViewController(line: line)
    }
    
    @objc func saveInvice() {
        //TODO: error handling
        guard let invoiceNumber = invoiceNumberInputView.text, !invoiceNumber.isEmpty else { return }
        let invoice = Invoice(invoiceNumber: invoiceNumber)
        invoiceLines.forEach{invoice.addLine($0)}
        presenter?.save(invoice: invoice)
    }
    
    private func navigateToInvocieViewController(line: InvoiceLine) {
        let viewController = container.resolve(InvoiceLineViewController.self)!
        viewController.delegate = self
        viewController.invoiceLine = line
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension SaveInvoiceViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return invoiceLines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "simplecell", for: indexPath) 
        cell.textLabel?.text = invoiceLines[indexPath.row].description
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            invoiceLines.remove(at: indexPath.row)
            tableView.reloadData()
        default:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let line = invoiceLines[indexPath.row]
        navigateToInvocieViewController(line: line)
    }
}

extension SaveInvoiceViewController: SaveInvoiceViewProtocol {
    func invoiceIsSaved() {
        navigationController?.popViewController(animated: true)
    }
}

extension SaveInvoiceViewController: InviceLineViewDelegate {
    func savedLine(line: InvoiceLine) {
        if let index = invoiceLines.firstIndex(of: line) {
            invoiceLines[index] = line
        } else {
            invoiceLines.append(line)
        }
        tableView.reloadData()
    }
}
