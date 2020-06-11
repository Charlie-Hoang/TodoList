//
//  Label.swift
//  TodoListApp
//
//  Created by Charlie on 8/6/20.
//  Copyright © 2020 C. All rights reserved.
//

import Foundation
import RealmSwift

class Label: Object{
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var title: String?
    
    public override static func primaryKey() -> String? { return "id" }
    
    convenience init(title: String) {
        self.init()
        self.title = title
    }
}
