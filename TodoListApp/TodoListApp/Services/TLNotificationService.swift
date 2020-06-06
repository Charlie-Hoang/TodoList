//
//  TLNotificationService.swift
//  TodoListApp
//
//  Created by Charlie on 6/6/20.
//  Copyright © 2020 C. All rights reserved.
//

import Foundation
import UserNotifications

enum TLTrigger{
    case once
    case everySecond
    case everyMinute
    case everyHour
    case everyDay
    case everyWeek
    case everyMonth
    case everyYear
    func triggerComponents() -> Set<Calendar.Component> {
        switch self {
        case .once:
            return [.year,.month,.day,.hour,.minute,.second,]
        case .everySecond:
            return [.nanosecond]
        case .everyMinute:
            return [.second,]
        case .everyHour:
            return [.minute,.second,]
        case .everyDay:
            return [.hour,.minute,.second,]
        case .everyWeek:
            return [.weekday,.hour,.minute,.second,]
        case .everyMonth:
            return [.day,.hour,.minute,.second,]
        case .everyYear:
            return [.month,.day,.hour,.minute,.second,]
        }
    }
}

class TLNotificationService {
    let notificationCenter = UNUserNotificationCenter.current()
    let options: UNAuthorizationOptions = [.alert, .sound, .badge]
    
    func requestPermission() {
        notificationCenter.requestAuthorization(options: options) {
            (didAllow, error) in
            if !didAllow {
                print("User has declined notifications")
            }
        }
    }
    func checkPermission() {
        notificationCenter.getNotificationSettings { (settings) in
          if settings.authorizationStatus != .authorized {
            // Notifications not allowed
          }
        }
    }
    func schedule(body: String?, time: Date?, trigger: TLTrigger) {
        removeAll()
        guard let time = time else {return}
        //content
        let content = UNMutableNotificationContent()
        content.title = "To-do List"
        content.body = body ?? ""
        content.sound = UNNotificationSound.default
        content.badge = 1
        //triger
        let triggerDate = Calendar.current.dateComponents(trigger.triggerComponents(), from: time)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true)
        //request
        let identifier = "Local Notification"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
    }
    func removeAll() {
        notificationCenter.removeAllDeliveredNotifications()
        notificationCenter.removeAllPendingNotificationRequests()
    }
}
