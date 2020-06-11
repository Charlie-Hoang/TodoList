//
//  TLNotificationService.swift
//  TodoListApp
//
//  Created by Charlie on 6/6/20.
//  Copyright © 2020 C. All rights reserved.
//

import Foundation
import UserNotifications



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
    func schedule(identifier: String?, body: String?, time: Date?, trigger: RepeatType, imgName: String?) {
//        print("dt1: \(imgData?.count ?? 0)")
        remove(identifier: identifier)
        guard let time = time else {return}
        //content
        let content = UNMutableNotificationContent()
        content.title = "To-do List"
        content.body = body ?? ""
        content.sound = UNNotificationSound.default
        content.badge = 1
        
        //attachment
        if let imgName = imgName {
            let filePath = imgName.components(separatedBy: ".")
            let url = Bundle.main.url(forResource: filePath[0], withExtension: filePath[1])
            do{
                let attachment = try UNNotificationAttachment(identifier: "", url: url!, options: nil)
                content.attachments = [attachment]
            } catch {
               print(error)
            }
//            if let attachment = UNNotificationAttachment.create(imageFileIdentifier: identifier ?? "Default", data: imgData!, options: nil){
//                content.attachments = [attachment]
//            }
        }
        //triger
        let triggerDate = Calendar.current.dateComponents(trigger.triggerComponents(), from: time)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true)
        //request
        let identifier = identifier ?? "Default"
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
    func remove(identifier: String?){
        if let identifier = identifier {
            notificationCenter.removeDeliveredNotifications(withIdentifiers: [identifier])
            notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
        }
    }
    func getPendingNotificationIds(completionHandler: @escaping ([String]?) -> Void) {
        var identifiers: [String] = []
        notificationCenter.getPendingNotificationRequests { ntfReqArray in
            identifiers = ntfReqArray.map{$0.identifier}
            completionHandler(identifiers)
        }
    }
    func getDeliveredNotificationIds(completionHandler: @escaping ([String]?) -> Void) {
        var identifiers: [String] = []
        notificationCenter.getDeliveredNotifications { unNtfArray in
            identifiers = unNtfArray.map{$0.request.identifier}
            completionHandler(identifiers)
        }
    }
}
