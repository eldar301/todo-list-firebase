//
//  TaskPresenter.swift
//  todo-list-firebase
//
//  Created by Eldar Goloviznin on 22/09/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import Foundation

enum TaskError {
    case invalidTitle
}

protocol TaskView: class {
    func setupNew()
    func set(title: String, description: String?, done: Bool)
    func error(error: TaskError)
}

class TaskPresenter {
    
    fileprivate let router: Router
    
    fileprivate var task: Task
    
    fileprivate let setupAsNew: Bool
    
    init(task: Task, router: Router) {
        self.task = task
        self.router = router
        setupAsNew = false
    }
    
    init(router: Router) {
        self.task = Task(title: "", description: nil, done: false)
        self.router = router
        setupAsNew = true
    }
    
    weak var view: TaskView? {
        didSet {
            if setupAsNew {
                view?.setupNew()
            } else {
                view?.set(title: task.title, description: task.description, done: task.done)
            }
        }
    }
    
    func set(title: String) {
        guard !title.isEmpty else {
            view?.error(error: .invalidTitle)
            return
        }
        task.title = title
    }
    
    func set(description: String?) {
        task.description = description
    }
    
    func toggleDone() -> Bool {
        assert(!setupAsNew)
        task.done.toggle()
        return task.done
    }
    
    func create() {
        guard !task.title.isEmpty else {
            view?.error(error: .invalidTitle)
            return
        }
        
        router.dismiss()
    }
    
    func dismiss() {
        router.dismiss()
    }
    
}
