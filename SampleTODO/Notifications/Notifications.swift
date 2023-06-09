//
//  Notifications.swift
//  kapsula
//
//  Created by Никита on 22.04.2022.
//

import Foundation
import UserNotificationsUI
import UserNotifications


class MainNotifications {
    static var shared = MainNotifications()
    func removeNotification(with id: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
    }
    func sendNotification(hour: Int, minute: Int, day: Int, _ name: String, id: String) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
            } else if let error {
                print(error.localizedDescription)
            }
        }
        let content = UNMutableNotificationContent()
        content.title = "Привет!"
        content.subtitle = "Невыполненное задание"
        content.body = name
        content.sound = UNNotificationSound.defaultCritical
        

        var dateComp = DateComponents()
        dateComp.hour = hour
        dateComp.minute = minute
        dateComp.day = day
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats: false)
        
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error {
                print(error.localizedDescription)
            }
        }
    }
}
