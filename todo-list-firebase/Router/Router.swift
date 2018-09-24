//
//  Router.swift
//  todo-list-firebase
//
//  Created by Eldar Goloviznin on 22/09/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import Foundation
import FirebaseAuth
import UIKit

class Router {
    
    fileprivate weak var currentViewController: UIViewController?
    
    init(viewController: UIViewController?) {
        self.currentViewController = viewController
    }
    
    func showRootScene() {
        if Auth.auth().currentUser != nil {
            showListScene()
        } else {
            showAuthScene()
        }
    }
    
    func showAuthScene() {
        let authVC = UIStoryboard(name: "Auth", bundle: nil).instantiateInitialViewController() as! AuthViewController
        let router = Router(viewController: authVC)
        let presenter = AuthPresenter(router: router)
        authVC.presenter = presenter
        present(viewController: authVC, modally: true)
    }
    
    func showListScene() {
        let navVC = UIStoryboard(name: "List", bundle: nil).instantiateInitialViewController() as! UINavigationController
        let listVC = navVC.viewControllers[0] as! ListViewController
        let router = Router(viewController: listVC)
        let presenter = ListPresenter(router: router)
        listVC.presenter = presenter
        present(viewController: navVC, modally: true)
    }
    
    func showTaskScene(task: Task?) {
        let taskVC = UIStoryboard(name: "Task", bundle: nil).instantiateInitialViewController() as! TaskViewController
        let router = Router(viewController: taskVC)
        var presenter: TaskPresenter
        if let task = task {
            presenter = TaskPresenter(task: task, router: router)
        } else {
            presenter = TaskPresenter(router: router)
        }
        taskVC.presenter = presenter
        present(viewController: taskVC, modally: true)
    }
    
    fileprivate func present(viewController: UIViewController, modally: Bool) {
        if !modally, let navVC = currentViewController?.navigationController {
            navVC.pushViewController(viewController, animated: true)
        } else {
            currentViewController?.present(viewController, animated: true)
        }
    }
    
    func dismiss() {
        if let navVC = currentViewController?.navigationController {
            navVC.popViewController(animated: true)
        } else {
            currentViewController?.dismiss(animated: true)
        }
    }

}
