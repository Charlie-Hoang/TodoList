//
//  TLDBConfiguration.swift
//  TodoListDB
//
//  Created by Charlie on 6/6/20.
//  Copyright © 2020 C. All rights reserved.
//

import Foundation
import RealmSwift

//configuration for TLDBService
protocol TLDBConfigurable {
    var realm: Realm{get}
}

struct TLDBConfiguration: TLDBConfigurable {
    var realm = try! Realm()
}
