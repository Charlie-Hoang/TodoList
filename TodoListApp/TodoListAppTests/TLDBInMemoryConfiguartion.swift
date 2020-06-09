//
//  TLDBInMemoryConfiguartion.swift
//  TodoListDBTests
//
//  Created by Charlie on 6/6/20.
//  Copyright © 2020 C. All rights reserved.
//

import Foundation
import RealmSwift

@testable import TodoListApp
func realmInMemory(_ name: String = UUID().uuidString) -> Realm {
    var conf = Realm.Configuration()
    conf.inMemoryIdentifier = name
    return try! Realm(configuration: conf)
}
struct TLDBInMemoryConfiguration: TLDBConfigurable {
    var realm = realmInMemory(#function)
    static let `default` = TLDBInMemoryConfiguration()
}
