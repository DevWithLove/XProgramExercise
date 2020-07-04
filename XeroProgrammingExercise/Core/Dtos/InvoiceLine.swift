import Foundation

struct InvoiceLine: Equatable {
    let invoiceLineId: Int
    let description: String
    let quantity: UInt
    let cost: Decimal
}

func == (left: InvoiceLine, right: InvoiceLine) -> Bool {
    return left.invoiceLineId == right.invoiceLineId
}

extension InvoiceLine {
    var total: Decimal {
        return Decimal(quantity) * cost
    }
}
