import Foundation

// Please see "InvoiceTests.swift"
class Invoice: Sequence, NSCopying, CustomStringConvertible {
    
    private var lineItems: [InvoiceLine] = []
    
    var number: String
    var date: Date
    
    var numberOfLines: Int {
        return lineItems.count
    }
    
    var total: Decimal {
        return lineItems.reduce(0) { $0 + $1.total }
    }
    
    var description: String {
        return  "Invoice Number:\(number), InvoiceDate:\(date.toString(dateFormat: "dd/MM/YYYY")), LineItemCount:\(numberOfLines)"
    }
    
    init(invoiceNumber: String, invoiceDate: Date = Date()) {
        self.number = invoiceNumber
        self.date = invoiceDate
    }
    
    func makeIterator() -> IndexingIterator<[InvoiceLine]> {
      return Array(lineItems).makeIterator()
    }
    
    subscript(line: Int) -> InvoiceLine {
        get {
            return lineItems[line]
        }
        set {
            lineItems[line] = newValue
        }
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Invoice(invoiceNumber: self.number, invoiceDate: self.date)
        copy.merge(sourceInvoice: self)
        return copy
    }
    
    func addLine(_ line: InvoiceLine) {
        lineItems.append(line)
    }
      
    func removeLine(lineId: Int) {
        lineItems.removeAll {$0.invoiceLineId == lineId }
    }
    
    /// MergeInvoices appends the items from the sourceInvoice to the current invoice
    func merge(sourceInvoice: Invoice) {
        lineItems.append(contentsOf: sourceInvoice)
    }
    
    /// Creates a deep clone of the current invoice (all fields and properties)
    func clone() -> Invoice {
        return copy() as! Invoice
    }
    
    /// order the lineItems by Id
    func oderLineItems() {
        lineItems = lineItems.sorted { $0.invoiceLineId < $1.invoiceLineId }
    }
    
    /// returns the number of the line items specified in the variable `max`
    func previewLineItems(_ max: Int) -> [InvoiceLine] {
        return Array(lineItems.prefix(max))
    }
   
    /// remove the line items in the current invoice that are also in the sourceInvoice
    func removeItems(from sourceInvoice: Invoice) {
        lineItems = lineItems.filter{ !sourceInvoice.contains($0)}
    }
    
    /// Outputs string containing the following (replace [] with actual values):
    /// Invoice Number: [InvoiceNumber], InvoiceDate: [DD/MM/YYYY], LineItemCount: [Number of items in LineItems]
    func toString() -> String {
        return description
    }
}

extension Invoice: Equatable {
    static func == (lhs: Invoice, rhs: Invoice) -> Bool {
       return lhs.number == rhs.number
    }
}
