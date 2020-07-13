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
import Swinject

class InvoicesViewController: UIViewController {
    
    // MARK: Variables
    private var sections = [GroupedSection<Date, Invoice>]()
    
    var presenter: InvoicesPresenterPresenterProtocol?
    var container: Container!
    
    // MARK: Views
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.dragDelegate = self
        tableView.dropDelegate = self
        tableView.dragInteractionEnabled = true
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.register(cellClass: InvoiceTableViewCell.self)
        tableView.register(viewClass: UITableViewHeaderFooterView.self)
        return tableView
    }()
    
    private lazy var searchBar: UISearchBar = {
        let view = UISearchBar()
        view.delegate = self
        view.placeholder = "Enter invoice number"
        view.showsCancelButton = true
        return view
    }()
    
    private lazy var tapGesture: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        return tap
    }()
    
    private lazy var rightBarItem: UIBarButtonItem = {
        let barItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addInvoice))
        return barItem
    }()
    
    private lazy var lgoinOutBarItem: UIBarButtonItem = {
        let barItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout))
        return barItem
    }()
    
    
    // MARK: iOS life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        view.addGestureRecognizer(tapGesture)
        presenter?.viewDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.loadInvoices(number: nil)
    }
    
    // MARK: Helpers
    
    @objc func addInvoice() {
        navigateToSaveInvoiceViewController(invoice: nil)
    }
    
    @objc func logout() {
        UserDefaults.standard.set(false, forKey: Switcher.loginKey)
        Switcher.updateRootVC()
    }
    
    private func setupUI() {
        title = LocalizableStringConstants.invoicesViewTitle
        navigationItem.rightBarButtonItem = rightBarItem
        navigationItem.leftBarButtonItem = lgoinOutBarItem
        view.addSubview(searchBar)
        view.addSubview(tableView)
        buildConstraints()
    }
    
    private func buildConstraints() {
        searchBar.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalTo(tableView.snp.top)
        }
        tableView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(searchBar)
            make.bottom.equalToSuperview()
        }
    }
    
    private func navigateToSaveInvoiceViewController(invoice: Invoice?) {
        let viewController = container.resolve(SaveInvoiceViewController.self)!
        viewController.invoiceNumber = invoice?.number
        viewController.invoiceLines = invoice?.map{$0} ?? []
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func reloadData(invoices: [Invoice]) {
        sections = GroupedSection<Date, Invoice>.group(items: invoices, by: { (invoice) -> Date in
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month, .day], from: invoice.date)
            return calendar.date(from: components)!
        }).sorted(by: { (sectionOne, sectionTwo) -> Bool in
            sectionOne.sectionItem < sectionTwo.sectionItem
        })
        tableView.reloadData()
    }
}

extension InvoicesViewController: InvoicesViewProtocol {
    func presentInvoices(_ invoices: [Invoice]) {
        reloadData(invoices: invoices)
    }
    
    func presentInvoiceDeleted(invoice: Invoice) {
        let alert = UIAlertController(title: "\(invoice) has been deleted.", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true) { [weak self] in
            guard let self = self else { return }
            self.presenter?.loadInvoices(number: nil)
            self.tableView.reloadData()
        }
    }
}

extension InvoicesViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        presenter?.loadInvoices(number: searchBar.text)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        presenter?.loadInvoices(number: nil)
    }
}

extension InvoicesViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDragDelegate, UITableViewDropDelegate {
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let invoice = getInvoice(by: indexPath)
        return []
    }
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let invoiceToMove = getInvoice(by: sourceIndexPath)
        let invoiceToMerge = getInvoice(by: destinationIndexPath)
        guard invoiceToMove != invoiceToMerge else { return }
        
        let alertView = UIAlertController(title: "Merge", message: "Are you sure you want to merge \(invoiceToMove) to \(invoiceToMerge) ?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
            invoiceToMerge.merge(sourceInvoice: invoiceToMove)
            self.presenter?.save(invoice: invoiceToMerge)
            self.presenter?.deleteInvoice(invoice: invoiceToMove)
        }
        let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        
        alertView.addAction(yesAction)
        alertView.addAction(cancelAction)
        present(alertView, animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  sections[section].rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InvoiceTableViewCell.cellId, for: indexPath) as! InvoiceTableViewCell
        let invoice = getInvoice(by: indexPath)
        cell.configureWithModel(invoice)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            let invoice = getInvoice(by: indexPath)
            presenter?.deleteInvoice(invoice: invoice)
        default:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigateToSaveInvoiceViewController(invoice: getInvoice(by: indexPath))
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: UITableViewHeaderFooterView.cellId)!
        view.textLabel?.text = sections[section].sectionItem.toString(dateFormat: "dd/MM/YYYY")
        return view
    }
    
    private func getInvoice(by indexPath: IndexPath) -> Invoice {
        return sections[indexPath.section].rows[indexPath.row]
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

