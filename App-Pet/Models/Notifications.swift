//
//  Notifications.swift
//  App-Pet
//
//  Created by Lucas Marques Bighi on 18/10/2019.
//  Copyright © 2019 Lucas Marques Bighi. All rights reserved.
//

import Foundation
import UserNotifications
import UIKit

class Notifications: NSObject {
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    func notificationRequest() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        notificationCenter.requestAuthorization(options: options) { (didAllow, error) in
            if !didAllow {
                print("User has declined notifications")
            }
        }
        notificationCenter.getNotificationSettings { (settings) in
            if settings.authorizationStatus != .authorized {
                // Notifications not allowed
            }
        }
        notificationCenter.delegate = self
    }
    
    func scheduleNotification(schedule: Schedule) {
        let title = "\(schedule.type.rawValue) do \(schedule.pets[0].name)"
        let body = "\(schedule.description) às \(Time.current.formatDate(date: schedule.date, format: .time))"
        let content = UNMutableNotificationContent()
        let userActions = "User Actions"
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        content.badge = PUser.shared.schedules!.lateSchedules() as NSNumber
        content.categoryIdentifier = userActions
        
        let components = Time.current.calendar.dateComponents([.year, .day, .hour, .minute], from: schedule.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        //let identifier = "Local Notification"
        let identifier = schedule.identifier!
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
        let doneAction = UNNotificationAction(identifier: "Done", title: "Marcar como feita", options: [])
        let lateAction = UNNotificationAction(identifier: "Late", title: "Marcar como atrasada", options: [])
        let category = UNNotificationCategory(identifier: userActions, actions: [doneAction, lateAction], intentIdentifiers: [], options: [])
        notificationCenter.setNotificationCategories([category])
    }
}

extension Notifications: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let identifier = notification.request.identifier
        PUser.shared.schedules?.mark(identifier, as: .late)
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let identifier = response.notification.request.identifier
        switch response.actionIdentifier {
        case UNNotificationDismissActionIdentifier:
            print("Dismiss Action")
        case UNNotificationDefaultActionIdentifier:
            print("Default")
        case "Done":
            PUser.shared.schedules?.mark(identifier, as: .done)
        case "Delete":
            print("Delete")
        default:
            print("Unknown action")
        }
        if response.notification.request.identifier == "Local Notification" {
            print("Handling notifications with Local Notification Identifier")
        }
        completionHandler()
    }
}
