/*
 Welcome to the Xero technical excercise!
 ---------------------------------------------------------------------------------
 The test consists of a small invoice application that has a number of issues.
 
 Your job is to fix them and make sure you can perform the functions in each method below and display the list of invoices from getInvoices() inside a UITableView.
 
 Note your first job is to get the solution compiling!
 
 Rules
 ---------------------------------------------------------------------------------
 * The entire solution must be written in Swift (UIKit or SwiftUI)
 * You can modify any of the code in this solution, split out classes, add projects etc
 * You can modify Invoice and InvoiceLine, rename and add methods, change property types (hint)
 * Feel free to use any libraries or frameworks you like
 * Feel free to write tests (hint)
 * Show off your skills!
 
 Good luck :)
 
 When you have finished the solution please zip it up and email it back to the recruiter or developer who sent it to you
 */

import UIKit
import SnapKit

class InvoicesViewController: UIViewController {
    
    // MARK: Variables
    private var invoices = [Invoice]()
    
    var presenter: InvoicesPresenterPresenterProtocol?
    
    // MARK: Views
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.register(cellClass: InvoiceTableViewCell.self)
        return tableView
    }()
    
    
    // MARK: iOS life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.loadInvoices()
    }
    
    // MARK: Helpers
    private func setupUI() {
        title = LocalizableStringConstants.invoicesViewTitle
        view.addSubview(tableView)
        buildConstraints()
    }
    
    private func buildConstraints() {
        tableView.snp.makeConstraints { (make) in
            make.top.leading.bottom.trailing.equalToSuperview()
        }
    }
}

extension InvoicesViewController: InvoicesViewProtocol {
    func presentInvoices(_ invoices: [Invoice]) {
        self.invoices = invoices
        tableView.reloadData()
    }
}

extension InvoicesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return invoices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InvoiceTableViewCell.cellId, for: indexPath) as! InvoiceTableViewCell
        let invoice = invoices[indexPath.row]
        cell.configureWithModel(invoice)
        return cell
    }
}

extension InvoiceTableViewCell: Configurable {
    func configureWithModel(_ invoice: Invoice) {
        headerView.titleLabel.text = String(format: LocalizableStringConstants.invoiceNumber, invoice.number)
        headerView.detailLabel.text = String(format: LocalizableStringConstants.invoiceDate, invoice.date.toString(dateFormat:"dd/MM/YYYY"))
        details = invoice.map{$0.toLineView()}
        footerView.titleLabel.text = LocalizableStringConstants.total
        footerView.detailLabel.text = invoice.total.currencyValue
    }
}

private extension InvoiceLine {
    func toLineView() -> InvoiceLineView {
        let view = InvoiceLineView()
        view.titleLabel.text = description
        view.detailLabel.text = "\(quantity) * \(cost.currencyValue)"
        return view
    }
}

