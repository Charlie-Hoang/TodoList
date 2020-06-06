//
//  Task.swift
//  TodoListDB
//
//  Created by Charlie on 6/6/20.
//  Copyright © 2020 C. All rights reserved.
//

import Foundation
import RealmSwift

public class Task: Object{
    @objc dynamic var id = UUID().uuidString
    @objc public dynamic var title: String?
    @objc public dynamic var fireDate: Date?
    
    public override static func primaryKey() -> String? { return "id" }
    
    public convenience init(title: String, fireDate: Date?) {
        self.init()
        self.title = title
        self.fireDate = fireDate
    }
}
