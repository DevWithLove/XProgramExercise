//
//  Configurable.swift
//  XeroProgrammingExercise
//
//  Created by Tony Mu on 3/07/20.
//  Copyright © 2020 Xero Ltd. All rights reserved.
//

import UIKit

/// The interface for configure view with a given model
protocol Configurable {
    associatedtype Model
    func configureWithModel(_:Model)
}
