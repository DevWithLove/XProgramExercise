//
//  UITableViewCellExtensions.swift
//  XeroProgrammingExercise
//
//  Created by Tony Mu on 3/07/20.
//  Copyright © 2020 Xero Ltd. All rights reserved.
//

import UIKit

extension UITableViewCell {
    /// Return a default cell Id as cell calss name
    public static var cellId: String {
        return String(describing: self).lowercased()
    }
}
