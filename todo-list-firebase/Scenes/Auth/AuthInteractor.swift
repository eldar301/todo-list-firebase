//
//  AuthInteractor.swift
//  todo-list-firebase
//
//  Created by Eldar Goloviznin on 24/09/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import Foundation
import FirebaseAuth

protocol AuthInteractorOutput: class {
    func update(withResult result: Result<Void>)
}

class AuthInteractor {
    
    weak var output: AuthInteractorOutput?
    
    func auth(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            self?.handleResult(result: result, error: error)
        }
    }
    
    func register(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            self?.handleResult(result: result, error: error)
        }
    }
    
    fileprivate func handleResult(result: AuthDataResult?, error: Error?) {
        if let error = error {
            output?.update(withResult: .error(error.localizedDescription))
            return
        }
        
        output?.update(withResult: .success(()))
    }
    
}
