//
//  ListPresenter.swift
//  todo-list-firebase
//
//  Created by Eldar Goloviznin on 22/09/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import Foundation

protocol ListView: class {
    func update(withHotTasks: [Task], withNormalTasks: [Task])
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
    
    func createTask() {
        router.showTaskScene(task: nil)
    }
    
}

extension ListPresenter: ListInteractorOutput {
    
    func update(withResult result: Result<[Task]>) {
        switch result {
        case .success(let tasks):
            var hotTasks: [Task] = []
            var normalTasks: [Task] = []
            
            for task in tasks {
                if let date = task.date, Calendar.current.isDateInToday(date) || date.timeIntervalSinceNow < 0 {
                    hotTasks.append(task)
                } else {
                    normalTasks.append(task)
                }
            }
            
            view?.update(withHotTasks: hotTasks, withNormalTasks: normalTasks)
            
        case .error(let description):
            print(description)
        }
    }
    
}
