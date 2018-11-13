//
//  Result.swift
//  todo-list-firebase
//
//  Created by Eldar Goloviznin on 13/11/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case error(String)
}

extension Result where T == Void {
    static var success: Result<Void> {
        return success(())
    }
}
