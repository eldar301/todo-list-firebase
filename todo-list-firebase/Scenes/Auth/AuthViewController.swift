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
    
    fileprivate var presenter: AuthPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        presenter = AuthPresenter(router: Router(viewController: self))
        presenter.view = self
    }
    
    @IBAction func login(_ sender: Any) {
        presenter.auth(email: emailTextField.text!, password: passwordTextField.text!)
    }
    
    @IBAction func register(_ sender: Any) {
        presenter.register(email: emailTextField.text!, password: passwordTextField.text!)
    }
    
}

extension AuthViewController: AuthView {
    
    func update(withErrorDescription description: String) {
        print(description)
    }
    
}
