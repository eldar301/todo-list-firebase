//
//  Task.swift
//  todo-list-firebase
//
//  Created by Eldar Goloviznin on 22/09/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import Foundation

struct Task {
    let id: String
    var title: String
    var description: String?
    var date: Date?
    var done: Bool
}
