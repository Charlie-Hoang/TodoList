//
//  Task.swift
//  TodoListDB
//
//  Created by Charlie on 6/6/20.
//  Copyright © 2020 C. All rights reserved.
//

import Foundation
import RealmSwift

class Task: Object{
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var title: String?
    @objc dynamic var imgAttachment: String?
    @objc dynamic var fireDate: Date?
    let finished = RealmOptional<Bool>()
    let repeatType = RealmOptional<Int>()
    
    @objc dynamic var label: Label?
    
    var pendingNotification = false
    
    public override static func primaryKey() -> String? { return "id" }
    
    convenience init(title: String?, fireDate: Date?) {
        self.init()
        self.title = title
        self.fireDate = fireDate
        self.finished.value = false
        self.repeatType.value = RepeatType.once.rawValue
        let labels = TLDBService().fetchLabels()
        self.label = labels.first
    }
    func isRepeat() -> Bool{
        if self.repeatType.value == RepeatType.once.rawValue {
            return false
        }
        return true
    }
    func scheduleNotification(){
        var imgData: NSData?
        if let imgAttachment = imgAttachment {
            imgData = UIImage(named: imgAttachment)?.pngData() as NSData?
        }
        TLNotificationService().schedule(identifier: id, body: title, time: fireDate, trigger: repeatType.value?.toRepeatType() ?? .once, imgData: imgData)
    }
    func removeNotification(){
        TLNotificationService().remove(identifier: id)
    }
    func processScheduleNotification(){
        pendingNotification = false
        if let finished = finished.value, finished {
            removeNotification()
            return
        }
        if repeatType.value == RepeatType.once.rawValue, let fireDate = fireDate, fireDate < Date() {
            removeNotification()
            return
        }
        pendingNotification = true
        scheduleNotification()
    }
}
