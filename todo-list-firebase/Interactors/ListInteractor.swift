//
//  ListInteractor.swift
//  todo-list-firebase
//
//  Created by Eldar Goloviznin on 24/09/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

enum TaskStatus {
    case added(Task)
    case modified(Task)
    case removed(Task)
}

protocol ListInteractorOutput: class {
    func update(withResult result: Result<[TaskStatus]>)
}

protocol ListInteractor {
    
    var output: ListInteractorOutput? { get set }
    
    func startListening() -> Bool    
}

class ListInteractorDefault: ListInteractor {
    
    weak var output: ListInteractorOutput?
    
    private lazy var db: Firestore = {
        let db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        return db
    }()
    
    func startListening() -> Bool {
        guard let userID = Auth.auth().currentUser?.uid else {
            return false
        }
        
        db.collection("users").document(userID).collection("tasks").addSnapshotListener { [weak self] snapshot, error in
            if let error = error {
                self?.output?.update(withResult: .error(error.localizedDescription))
                return
            }
            
            var tasks: [TaskStatus] = []
            
            for change in snapshot!.documentChanges {
                let document = change.document
                let data = document.data()
                
                let id = document.documentID
                let title = data["title"] as! String
                let description = data["description"] as? String
                let date = (document.get("date") as? Timestamp)?.dateValue()
                let task = Task(id: id,
                                title: title,
                                description: description,
                                date: date,
                                done: false)
                
                switch change.type {
                case .added:
                    tasks.append(.added(task))
                    
                case .modified:
                    tasks.append(.modified(task))
                    
                case .removed:
                    tasks.append(.removed(task))
                    
                }
            }
            
            self?.output?.update(withResult: .success(tasks))
        }
        
        return true
    }
    
}
