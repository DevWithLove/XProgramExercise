//
//  UITableViewExtensions.swift
//  XeroProgrammingExercise
//
//  Created by Tony Mu on 3/07/20.
//  Copyright © 2020 Xero Ltd. All rights reserved.
//

import UIKit

extension UITableView {
    /// Register cell with the default cell id
    public func register<T: UITableViewCell>(cellClass: T.Type) {
        register(cellClass, forCellReuseIdentifier: cellClass.cellId)
    }
}
