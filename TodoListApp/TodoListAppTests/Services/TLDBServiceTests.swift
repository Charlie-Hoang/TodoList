//
//  TLDBServiceTests.swift
//  TodoListDBTests
//
//  Created by Charlie on 6/6/20.
//  Copyright © 2020 C. All rights reserved.
//

import XCTest
@testable import TodoListApp
//Task
class TLDBServiceTests: XCTestCase {
    let dbService = TLDBService(config: TLDBInMemoryConfiguration.default)
    
    func initTasksDB(){
        let task1 = Task(title: "go to work", fireDate: Date())
        task1.finished.value = true
        let task2 = Task(title: "go to eat", fireDate: Date())
        task2.finished.value = false
        let task3 = Task(title: "go to sleep", fireDate: Date())
        dbService.createTask(task: task1)
        dbService.createTask(task: task2)
        dbService.createTask(task: task3)
    }
    func testFetchTasks() {
        dbService.deleteAllTasks()
        initTasksDB()
        let tasks = dbService.fetchTasks().sorted(byKeyPath: "fireDate")
        XCTAssert(tasks.count==3, "should be 3 tasks")
        XCTAssert(tasks.first?.title == "go to work", "should be equals")
        XCTAssert((tasks.first?.finished.value)!, "should be true")
        XCTAssert(tasks[1].title == "go to eat", "should be equals")
        XCTAssert(!tasks[1].finished.value!, "should be false")
        XCTAssert(tasks[2].title == "go to sleep", "should be equals")
        XCTAssert(!tasks[2].finished.value!, "should be false")
        dbService.deleteAllTasks()
    }
    func testUpdateTasks(){
        dbService.deleteAllTasks()
        initTasksDB()
        let tasks = dbService.fetchTasks()
        let task = tasks.first!
        dbService.update(task: task) {
            task.title = "wake up!"
        }
        let newTasks = dbService.fetchTasks()
        XCTAssert(newTasks.first?.title=="wake up!", "new task should be titled 'wake up!'")
        dbService.deleteAllTasks()
    }
    func testDeleteTasks(){
        dbService.deleteAllTasks()
        initTasksDB()
        let tasks = dbService.fetchTasks()
        let task = tasks.first!
        dbService.deleteTask(task: task)
        let newTasks = dbService.fetchTasks()
        XCTAssert(newTasks.count==2, "should be 2 tasks")
        dbService.deleteAllTasks()
        let newTasks2 = dbService.fetchTasks()
        XCTAssert(newTasks2.count==0, "should be no task")
    }
}
//Label
extension TLDBServiceTests{
    func initLabelsDB(){
        let label1 = Label(title: "Morning")
        let label2 = Label(title: "Work")
        let label3 = Label(title: "Health")
        dbService.createLabel(label: label1)
        dbService.createLabel(label: label2)
        dbService.createLabel(label: label3)
    }
    func testFetchLabels() {
        dbService.deleteAllLabels()
        initLabelsDB()
        let labels = dbService.fetchLabels()
        XCTAssert(labels.count==3, "should be 3 tasks")
        XCTAssert(labels.first?.title == "Morning", "should be equals")
        XCTAssert(labels[1].title == "Work", "should be equals")
        XCTAssert(labels[2].title == "Health", "should be equals")
        dbService.deleteAllLabels()
    }
    func testUpdateLabels(){
        dbService.deleteAllLabels()
        initLabelsDB()
        let labels = dbService.fetchLabels()
        let label = labels.first!
        dbService.update(label: label) {
            label.title = "Eating"
        }
        let newLabels = dbService.fetchLabels()
        XCTAssert(newLabels.first?.title=="Eating", "new label should be titled 'Eating'")
        dbService.deleteAllTasks()
    }
    func testDeleteLabels(){
        dbService.deleteAllLabels()
        initLabelsDB()
        let labels = dbService.fetchLabels()
        let label = labels.first!
        dbService.deleteLabel(label: label)
        let newLabels = dbService.fetchLabels()
        XCTAssert(newLabels.count==2, "should be 2 labels")
        dbService.deleteAllLabels()
        let newLabels2 = dbService.fetchLabels()
        XCTAssert(newLabels2.count==0, "should be no label")
    }
}
