//
//  AuthViewController.swift
//  todo-list-firebase
//
//  Created by Eldar Goloviznin on 24/09/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    var presenter: AuthPresenter!
    
    override func viewDidLoad() {
        presenter.view = self
    }
    
    @IBAction func login(_ sender: Any) {
        presenter.auth(email: emailTextField.text!, password: passwordTextField.text!)
    }
    
    @IBAction func register(_ sender: Any) {
        presenter.register(email: emailTextField.text!, password: passwordTextField.text!)
    }
    
    @IBAction func skip(_ sender: Any) {
        presenter.skip()
    }
    
}

extension AuthViewController: AuthView {
    
    func update(withErrorDescription description: String) {
        print(description)
    }
    
}
