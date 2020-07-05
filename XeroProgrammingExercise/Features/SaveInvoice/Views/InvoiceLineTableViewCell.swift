//
//  InvoiceLineTableViewCell.swift
//  XeroProgrammingExercise
//
//  Created by Tony Mu on 5/07/20.
//  Copyright © 2020 Xero Ltd. All rights reserved.
//

import UIKit

class InvoiceLineTableViewCell: UITableViewCell {
    
    lazy var lineView: InvoiceLineView = InvoiceLineView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.top.leading.equalToSuperview().offset(20)
            make.bottom.trailing.equalToSuperview().offset(-20)
        }
    }
}
