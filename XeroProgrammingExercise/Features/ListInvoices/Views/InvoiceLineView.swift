//
//  InvoiceLineView.swift
//  XeroProgrammingExercise
//
//  Created by Tony Mu on 3/07/20.
//  Copyright © 2020 Xero Ltd. All rights reserved.
//

import UIKit

class InvoiceLineView: UIStackView {
    
    // MARK: - Contants
    let kSpacing: CGFloat = 8
    
    // MARK: - Properties
    
    lazy var titleLabel: UILabel = UILabel(aligment: .left)
    
    lazy var detailLabel: UILabel = UILabel(aligment: .right)
    
    init() {
        super.init(frame: .zero)
        axis = .horizontal
        spacing = kSpacing
        distribution = .fillEqually
        addArrangedSubview(titleLabel)
        addArrangedSubview(detailLabel)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reset() {
        titleLabel.text = nil
        detailLabel.text = nil
    }
}

private extension UILabel {
    convenience init(aligment: NSTextAlignment) {
        self.init()
        textColor = .label
        font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
        textAlignment = aligment
        numberOfLines = 0
    }
}
