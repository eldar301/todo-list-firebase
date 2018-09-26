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

enum Result<T> {
    case success(T)
    case error(String)
}

protocol ListInteractorOutput: class {
    func update(withResult result: Result<[Task]>)
}

class ListInteractor {
    
    weak var output: ListInteractorOutput?
    
    fileprivate lazy var db: Firestore = {
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
            
            let tasks = snapshot!.documents.map({ document -> Task in
                let id = document.documentID
                let data = document.data()
                let title = data["title"] as! String
                let description = data["description"] as? String
                let date = (document.get("date") as? Timestamp)?.dateValue()
                return Task(id: id,
                            title: title,
                            description: description,
                            date: date,
                            done: false)
            })
            
            self?.output?.update(withResult: .success(tasks))
        }
        
        return true
    }
    
}
