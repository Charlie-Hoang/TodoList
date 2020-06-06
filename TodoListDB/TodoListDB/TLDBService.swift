//
//  TLDBService.swift
//  TodoListDB
//
//  Created by Charlie on 6/6/20.
//  Copyright © 2020 C. All rights reserved.
//

import Foundation
import RealmSwift

//Protocol
protocol TLDBServiceProtocol{
    var configuration: TLDBConfigurable{get}
}
//Service
public class TLDBService{
    private var database: Realm!
    private var configuration: TLDBConfigurable
    public init(config: TLDBConfigurable) {
        self.configuration = config
        self.database = config.realm
    }
    init(){
        self.configuration = TLDBConfiguration()
        self.database = self.configuration.realm
    }
}

extension TLDBService{
    public func createTask(task: Task){
        try! database.write{
            database.add(task)
        }
    }
    public func fetchTasks() -> Results<Task>{
        return database.objects(Task.self)
    }
    public func fetchTask(id: String) -> Task?{
        return database.object(ofType: Task.self, forPrimaryKey: id)
    }
    func deleteTask(task: Task){
        try! database.write {
            database.delete(task)
        }
    }
    func deleteAllTasks(){
        let tasks = self.fetchTasks()
        if !tasks.isEmpty{
            try! database.write{
                database.delete(tasks)
            }
        }
    }
    func update(task: Task, block: ()->()){
        try! database.write{
            block()
            database.add(task, update: .modified)
        }
    }
}
