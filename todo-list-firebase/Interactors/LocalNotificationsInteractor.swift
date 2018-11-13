//
//  LocalNotificationsInteractor.swift
//  todo-list-firebase
//
//  Created by Eldar Goloviznin on 21/10/2018.
//  Copyright © 2018 Eldar Goloviznin. All rights reserved.
//

import Foundation
import UserNotifications
import UIKit

protocol LocalNotificationsInteractorOutput: class {
    func accessNotGranted()
}

protocol LocalNotificationsInteractor {
    
    var output: LocalNotificationsInteractorOutput? { get set }
    
    func addNotificationFor(task: Task)
    func removeNotificationFor(task: Task)
}

class LocalNotificationsInteractorDefault: LocalNotificationsInteractor {
    
    weak var output: LocalNotificationsInteractorOutput?
    
    init() {
        let markAsDoneAction = UNNotificationAction(identifier: "mark-as-done", title: "Done", options: [])
        let remindLaterAction = UNNotificationAction(identifier: "remind-later", title: "Remind later", options: [])
        
        let taskDeadlineIsReachedCategory = UNNotificationCategory(identifier: "task-deadline",
                                                                   actions: [markAsDoneAction, remindLaterAction],
                                                                   intentIdentifiers: [],
                                                                   hiddenPreviewsBodyPlaceholder: "%u tasks reached deadline",
                                                                   options: [])
        
        UNUserNotificationCenter.current().setNotificationCategories([taskDeadlineIsReachedCategory])
    }
    
    func addNotificationFor(task: Task) {
        manageNotificationCenter { center, settings in
            if settings.alertSetting == .enabled {
                let content = UNMutableNotificationContent()
                content.title = task.title
                if let description = task.description {
                    content.body = description
                }
                
                content.threadIdentifier = "todo-list-firebase"
                content.categoryIdentifier = "task-deadline"
                
                content.sound = .default
                
                let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: task.date!)
                let dateTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                
                let request = UNNotificationRequest(identifier: task.id, content: content, trigger: dateTrigger)
                
                center.add(request, withCompletionHandler: { error in
                    print(error?.localizedDescription)
                })
            }
        }
        
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            print(requests.count)
        }
    }
    
    func removeNotificationFor(task: Task) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [task.id])
    }
    
    private func manageNotificationCenter(action: @escaping (_: UNUserNotificationCenter, _: UNNotificationSettings) -> ()) {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            guard granted else {
                self.output?.accessNotGranted()
                return
            }
            
            center.getNotificationSettings(completionHandler: { settings in
                action(center, settings)
            })
        }
    }
    
}
