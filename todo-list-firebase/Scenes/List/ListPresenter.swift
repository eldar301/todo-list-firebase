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
    
    private let router: Router
    
    private var hotTasks: [Task] = []
    private var normalTasks: [Task] = []
    
    let listInteractor: ListInteractor
    
    let localNotificationsInteractor: LocalNotificationsInteractor
    
    init(router: Router, listInteractor: ListInteractor, localNotificationsInteractor: LocalNotificationsInteractor) {
        self.router = router
        self.listInteractor = listInteractor
        self.localNotificationsInteractor = localNotificationsInteractor
    }
    
    weak var view: ListView?
    
    func startListening() {
        _ = listInteractor.startListening()
    }
    
    func showTask(task: Task) {
        router.showTaskScene(task: task)
    }
    
    func createTask() {
        router.showTaskScene(task: nil)
    }
    
}

extension ListPresenter: ListInteractorOutput {
    
    func update(withResult result: Result<[TaskStatus]>) {
        switch result {
        case .success(let taskStatuses):
            for status in taskStatuses {
                switch status {
                case .modified(let task):
                    if let index = hotTasks.firstIndex(where: { $0 == task }) {
                        hotTasks.remove(at: index)
                    } else if let index = normalTasks.firstIndex(where: { $0 == task }) {
                        normalTasks.remove(at: index)
                    }
                    
                    fallthrough
                    
                case .added(let task):                    
                    if let date = task.date, Calendar.current.isDateInToday(date) || date.timeIntervalSinceNow < 0 {
                        hotTasks.append(task)
                    } else {
                        normalTasks.append(task)
                    }
                    
                    if task.date != nil {
                        localNotificationsInteractor.addNotificationFor(task: task)
                    } else {
                        localNotificationsInteractor.removeNotificationFor(task: task)
                    }
                    
                case .removed(let task):
                    if let index = hotTasks.firstIndex(where: { $0 == task }) {
                        hotTasks.remove(at: index)
                    } else if let index = normalTasks.firstIndex(where: { $0 == task }) {
                        normalTasks.remove(at: index)
                    }
                    
                    localNotificationsInteractor.removeNotificationFor(task: task)
                }
                
            }
            
            view?.update(withHotTasks: hotTasks, withNormalTasks: normalTasks)
            
        case .error(let description):
            print(description)
        }
    }
    
}

extension ListPresenter: LocalNotificationsInteractorOutput {
    
    func accessNotGranted() {
        
    }
    
}
