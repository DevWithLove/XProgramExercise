//
//  LoginViewController.swift
//  XeroProgrammingExercise
//
//  Created by Tony Mu on 12/07/20.
//  Copyright © 2020 Xero Ltd. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.addTarget(self, action: #selector(login), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        
        view.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
    }
    
    @objc func login() {
        UserDefaults.standard.set(true, forKey: Switcher.loginKey)
        Switcher.updateRootVC()
    }
}
