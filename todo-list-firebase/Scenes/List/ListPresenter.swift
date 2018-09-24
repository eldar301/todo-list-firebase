//
//  ListPresenter.swift
//  todo-list-firebase
//
//  Created by Eldar Goloviznin on 22/09/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import Foundation

protocol ListView: class {
    func update(withTasks: [Task])
}

class ListPresenter {
    
    fileprivate let router: Router
    
    init(router: Router) {
        self.router = router
    }
    
    weak var view: ListView?
    
    lazy var interactor: ListInteractor = {
        let interactor = ListInteractor()
        interactor.output = self
        return interactor
    }()
    
    func startListening() {
        _ = interactor.startListening()
    }
    
    func showTask(task: Task) {
        router.showTaskScene(task: task)
    }
    
}

extension ListPresenter: ListInteractorOutput {
    
    func update(withResult result: Result<[Task]>) {
        switch result {
        case .success(let tasks):
            view?.update(withTasks: tasks)
            
        case .error(let description):
            print(description)
        }
    }
    
}
