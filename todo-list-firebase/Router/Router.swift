//
//  Router.swift
//  todo-list-firebase
//
//  Created by Eldar Goloviznin on 22/09/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import Foundation
import UIKit

class Router {
    
    fileprivate weak var currentViewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.currentViewController = viewController
    }
    
    func dismiss() {
        if let navVC = currentViewController?.navigationController {
            navVC.popViewController(animated: true)
        } else {
            currentViewController?.dismiss(animated: true)
        }
    }

}
