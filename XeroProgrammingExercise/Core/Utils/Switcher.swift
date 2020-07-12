//
//  Switcher.swift
//  XeroProgrammingExercise
//
//  Created by Tony Mu on 12/07/20.
//  Copyright © 2020 Xero Ltd. All rights reserved.
//

import UIKit

class Switcher {
    static let loginKey = "status"
    
    static func updateRootVC() {
        let status = UserDefaults.standard.bool(forKey: loginKey)
        var rootVc: UIViewController?
        
        if status {
            rootVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "invoicesNavigationController") as! UINavigationController
        }else {
            rootVc = LoginViewController()
        }
        
        let appDelegates = UIApplication.shared.delegate as! AppDelegate
        appDelegates.window?.rootViewController = rootVc
    }
    
}
