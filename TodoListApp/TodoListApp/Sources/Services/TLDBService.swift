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
class TLDBService{
    private var database: Realm!
    private var configuration: TLDBConfigurable
    init(config: TLDBConfigurable) {
        self.configuration = config
        self.database = config.realm
    }
    init(){
        self.configuration = TLDBConfiguration()
        self.database = self.configuration.realm
    }
    func initialDB(){
        let initialLabel1 = Label(title: "Morning")
        let initialLabel2 = Label(title: "Health")
        let initialLabel3 = Label(title: "Todo")
        createLabels(labels: [initialLabel1, initialLabel2, initialLabel3])
        
        let newTask = Task(title: "wake up!", fireDate: Date())
        newTask.label = initialLabel1
        createTask(task: newTask)
    }
}
//Task
extension TLDBService{
    func createTask(task: Task){
        try! database.write{
            database.add(task)
            task.processScheduleNotification()
        }
    }
    func fetchTasks() -> Results<Task>{
        return database.objects(Task.self)
    }
    func fetchTask(id: String) -> Task?{
        return database.object(ofType: Task.self, forPrimaryKey: id)
    }
    func deleteTask(task: Task){
        try! database.write {
            task.processScheduleNotification()
            database.delete(task)
        }
    }
    func deleteAllTasks(){
        let tasks = self.fetchTasks()
        if !tasks.isEmpty{
            try! database.write{
                for task in tasks{
                    task.processScheduleNotification()
                }
                database.delete(tasks)
            }
        }
    }
    func update(task: Task, block: ()->()){
        try! database.write{
            block()
            task.processScheduleNotification()
            database.add(task, update: .modified)
        }
    }
}
//Label
extension TLDBService{
    func createLabel(label: Label){
        try! database.write{
            database.add(label)
        }
    }
    func createLabels(labels: [Label]){
        for item in labels {
            createLabel(label: item)
        }
    }
    func fetchLabels() -> Results<Label>{
        return database.objects(Label.self)
    }
    public func fetchLabel(id: String) -> Label?{
        return database.object(ofType: Label.self, forPrimaryKey: id)
    }
    func deleteLabel(label: Label){
        try! database.write {
            database.delete(label)
        }
    }
    func deleteAllLabels(){
        let labels = self.fetchLabels()
        if !labels.isEmpty{
            try! database.write{
                database.delete(labels)
            }
        }
    }
    func update(label: Label, block: ()->()){
        try! database.write{
            block()
            database.add(label, update: .modified)
        }
    }
}
