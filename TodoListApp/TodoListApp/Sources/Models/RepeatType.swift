//
//  RepeatType.swift
//  TodoListApp
//
//  Created by Charlie on 9/6/20.
//  Copyright © 2020 C. All rights reserved.
//

import Foundation
import RealmSwift

enum RepeatType: Int{
    case once = 0
    case everySecond = 1
    case everyMinute = 2
    case hourly = 3
    case daily = 4
    case weekly = 5
    case monthly = 6
    case yearly = 7
    func triggerComponents() -> Set<Calendar.Component> {
        switch self {
        case .once:
            return [.year,.month,.day,.hour,.minute,.second,]
        case .everySecond:
            return [.nanosecond]
        case .everyMinute:
            return [.second,]
        case .hourly:
            return [.minute,.second,]
        case .daily:
            return [.hour,.minute,.second,]
        case .weekly:
            return [.weekday,.hour,.minute,.second,]
        case .monthly:
            return [.day,.hour,.minute,.second,]
        case .yearly:
            return [.month,.day,.hour,.minute,.second,]
        }
    }
    func toString() -> String{
        switch self {
        case .once:
            return "Once"
        case .everySecond:
            return "EverySecond"
        case .everyMinute:
            return "EveryMinute"
        case .hourly:
            return "Hourly"
        case .daily:
            return "Daily"
        case .weekly:
            return "Weekly"
        case .monthly:
            return "Monthly"
        case .yearly:
            return "Yearly"
        }
    }
}
extension Int{
    func toRepeatType() -> RepeatType?{
        if self >= RepeatType.once.rawValue && self <= RepeatType.yearly.rawValue{
            return RepeatType(rawValue: self)
        }
        return nil
    }
}
