//
//  AuthPresenter.swift
//  todo-list-firebase
//
//  Created by Eldar Goloviznin on 24/09/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import Foundation

protocol AuthView: class {
    func update(withErrorDescription: String)
}

class AuthPresenter {
    
    fileprivate let router: Router
    
    init(router: Router) {
        self.router = router
    }
    
    weak var view: AuthView?
    
    lazy var interactor: AuthInteractor = {
       let interactor = AuthInteractor()
        interactor.output = self
        return interactor
    }()
    
    func auth(email: String, password: String) {
        interactor.auth(email: email, password: password)
    }
    
    func register(email: String, password: String) {
        interactor.register(email: email, password: password)
    }
    
}

extension AuthPresenter: AuthInteractorOutput {
    
    func update(withResult result: Result<Void>) {
        switch result {
        case .success(()):
            router.dismiss()
            
        case .error(let description):
            view?.update(withErrorDescription: description)
        }
    }
    
}
