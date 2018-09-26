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
        
        db.collection("users")
            .document(userID)
            .collection("tasks")
            .addDocument(data: dataFrom(task: task).filter({ $0.value != nil }) as [String : Any])
    }
    
    func edit(task: Task) {
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }
        
        let documentReference = db.collection("users").document(userID).collection("tasks").document(task.id)
        
        if task.done {
            documentReference.delete()
        } else {
            documentReference.updateData(dataFrom(task: task).mapValues({ ($0 == nil) ? FieldValue.delete() : $0 }) as [AnyHashable : Any])
        }
    }
    
    fileprivate func dataFrom(task: Task) -> [String: Any?] {
        return ["title": task.title,
                "description": task.description,
                "date": task.date]
    }
    
}
