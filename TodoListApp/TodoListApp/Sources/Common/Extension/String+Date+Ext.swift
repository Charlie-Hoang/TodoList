//
//  String+Date+Ext.swift
//  TodoListApp
//
//  Created by Charlie on 8/6/20.
//  Copyright © 2020 C. All rights reserved.
//

import UIKit

extension Date{
    func tlString() -> String?{
        let formater = DateFormatter()
        formater.dateFormat = "yyyy-MM-dd hh:mm a"
        return formater.string(from: self)
    }
    func add1Day() -> Date{
        return Calendar.current.date(byAdding: .day, value: 1, to: self)!
    }
}

extension String{
    func tlDate() -> Date{
        let formater = DateFormatter()
        formater.dateFormat = "yyyy-MM-dd hh:mm a"
        return formater.date(from: self) ?? Date()
    }
}
