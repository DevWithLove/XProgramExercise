//
//  RealmStorage.swift
//  XeroProgrammingExercise
//
//  Created by Tony Mu on 6/07/20.
//  Copyright © 2020 Xero Ltd. All rights reserved.
//
import Foundation
import RealmSwift

class RealmStorage: InvoiceRepositoryProtocol {
    
    private let realm = try! Realm()
    
    func get() -> [Invoice] {
        return realm.objects(InvoiceDto.self).map{$0.toInvoice()}
    }
    
    func save(invoice: Invoice) {
        // Is a existing invoice, then update the invoice
        if let updateDto = getInvoice(number: invoice.number) {
            try! realm.write {
                updateDto.number = invoice.number
                updateDto.date = invoice.date
                updateDto.lines.removeAll()
                updateDto.lines.append(objectsIn: invoice.map{$0.toInvoiceLineDto()})
            }
            return
        }
        // Otherwise, add invoice
        try! realm.write {
            realm.add(invoice.toInvocieDto())
        }
    }
    
    func delete(invoice: Invoice) {
        guard let dto = getInvoice(number: invoice.number) else { return }
        try! realm.write {
            realm.delete(dto)
        }
    }
    
    private func getInvoice(number: String) -> InvoiceDto? {
        let predicate = NSPredicate(format: "number = %@",number)
        return realm.objects(InvoiceDto.self).filter(predicate).first
    }
}

class InvoiceDto: Object {
    @objc dynamic var number: String = ""
    @objc dynamic var date: Date = Date(timeIntervalSince1970: 1)
    var lines = List<InvoiceLineDto>()
    
    override static func indexedProperties() -> [String] {
        return ["number"]
    }
}


class InvoiceLineDto: Object {
    @objc dynamic var invoiceLineId: Int = -1
    @objc dynamic var lineDescription: String = ""
    @objc dynamic var quantity: Int = 0
    @objc dynamic var cost: Double = 0
}

private extension InvoiceDto {
    func toInvoice() -> Invoice {
        let invoice = Invoice(invoiceNumber: number, invoiceDate: date)
        lines.forEach{invoice.addLine($0.toInvoiceLine())}
        return invoice
    }
}

private extension InvoiceLineDto {
    func toInvoiceLine() -> InvoiceLine {
        return InvoiceLine(invoiceLineId: invoiceLineId,
                           description: lineDescription,
                           quantity: UInt(quantity),
                           cost: Decimal(cost))
    }
}

private extension InvoiceLine {
    func toInvoiceLineDto() -> InvoiceLineDto {
        let dto = InvoiceLineDto()
        dto.invoiceLineId = invoiceLineId
        dto.lineDescription = description
        dto.quantity = Int(quantity)
        dto.cost = cost.doubleValue
        return dto
    }
}

private extension Invoice {
    func toInvocieDto() -> InvoiceDto {
        let dto = InvoiceDto()
        dto.number = number
        dto.date = date
        dto.lines.append(objectsIn: map{$0.toInvoiceLineDto()})
        return dto
    }
}
