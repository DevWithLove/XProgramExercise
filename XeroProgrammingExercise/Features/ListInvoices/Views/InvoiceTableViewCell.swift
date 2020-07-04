//
//  InvoiceTableViewCell.swift
//  XeroProgrammingExercise
//
//  Created by Tony Mu on 3/07/20.
//  Copyright © 2020 Xero Ltd. All rights reserved.
//

import UIKit

class InvoiceTableViewCell: UITableViewCell {
    
    // MARK:- Contants
    
    let kSpacing: CGFloat = 8
    let kHeaderFont = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
    let kFooterFont = UIFont.boldSystemFont(ofSize: UIFont.smallSystemFontSize)
    let kLargeMargin = 20
    let kMiddleMargin = 10
    
    // MARK:- Properties
    
    var details: [InvoiceLineView]? {
        didSet {
            detailView.arrangedSubviews.forEach{ view in
                view.removeFromSuperview()
            }
            details?.forEach{ lineView in
                detailView.addArrangedSubview(lineView)
            }
        }
    }
    
    // MARK:- UI Elements
    
    lazy var headerView: InvoiceLineView = {
        let view = InvoiceLineView()
        view.titleLabel.font = kHeaderFont
        view.detailLabel.font = kHeaderFont
        return view
    }()
    
    private lazy var detailView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.spacing = kSpacing
        stackView.distribution = .fill
        return stackView
    }()
    
    lazy var footerView: InvoiceLineView = {
        let view = InvoiceLineView()
        view.titleLabel.font = kFooterFont
        view.detailLabel.font = kFooterFont
        return view
    }()
    
    // MARK:- Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        headerView.reset()
        footerView.reset()
        details = nil
    }
    
    private func setupUI() {
        contentView.addSubview(headerView)
        contentView.addSubview(detailView)
        contentView.addSubview(footerView)
        buildConstraints()
    }
    
    private func buildConstraints(){
        headerView.snp.makeConstraints { (make) in
            make.top.leading.equalToSuperview().offset(kLargeMargin)
            make.trailing.equalToSuperview().inset(kLargeMargin)
            make.bottom.equalTo(detailView.snp.top).offset(-kMiddleMargin)
        }
        detailView.snp.makeConstraints { (make) in
            make.leading.equalTo(headerView.snp.leading)
            make.trailing.equalTo(headerView.snp.trailing)
        }
        footerView.snp.makeConstraints { (make) in
            make.top.equalTo(detailView.snp.bottom).offset(kMiddleMargin)
            make.leading.equalTo(headerView.snp.leading)
            make.trailing.equalTo(headerView.snp.trailing)
            make.bottom.equalToSuperview()
        }
    }
}
