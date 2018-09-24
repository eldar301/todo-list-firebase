//
//  TaskInteractor.swift
//  todo-list-firebase
//
//  Created by Eldar Goloviznin on 24/09/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class TaskInteractor {
    
    fileprivate lazy var db: Firestore = {
        let db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        return db
    }()
    
    func add(task: Task) {
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }
        
        db.collection("users").document(userID).collection("tasks").addDocument(data: dataFrom(task: task))
    }
    
    func edit(task: Task) {
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }
        
        db.collection("users").document(userID).collection("tasks").document(task.id).updateData(dataFrom(task: task))
    }
    
    fileprivate func dataFrom(task: Task) -> [String: Any] {
        var dateString = ""
        if let date = task.date {
            dateString = "\(date.timeIntervalSince1970)"
        }
        
        return ["title": task.title,
                "description": task.description ?? "",
                "date": dateString,
                "done": task.done]
    }
    
}
