//
//  TLDBServiceTests.swift
//  TodoListDBTests
//
//  Created by Charlie on 6/6/20.
//  Copyright © 2020 C. All rights reserved.
//

import XCTest
@testable import TodoListDB

class TLDBServiceTests: XCTestCase {
    let dbService = TLDBService(config: TLDBInMemoryConfiguration.default)
    
    func initDB(){
        let task1 = Task(title: "go to work", fireDate: Date())
        let task2 = Task(title: "go to eat", fireDate: Date())
        let task3 = Task(title: "go to sleep", fireDate: Date())
        dbService.createTask(task: task1)
        dbService.createTask(task: task2)
        dbService.createTask(task: task3)
    }
    func testFetchTasks() {
        dbService.deleteAllTasks()
        initDB()
        let tasks = dbService.fetchTasks().sorted(byKeyPath: "fireDate")
        XCTAssert(tasks.count==3, "should be 3 tasks")
        XCTAssert(tasks.first?.title == "go to work", "should be equals")
        XCTAssert(tasks[1].title == "go to eat", "should be equals")
        XCTAssert(tasks[2].title == "go to sleep", "should be equals")
        dbService.deleteAllTasks()
    }
    func testUpdateGroups(){
        dbService.deleteAllTasks()
        initDB()
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
        initDB()
        let tasks = dbService.fetchTasks()
        let task = tasks.first!
        dbService.deleteTask(task: task)
        let newTasks = dbService.fetchTasks()
        XCTAssert(newTasks.count==2, "should be 2 tasks")
        dbService.deleteAllTasks()
        let newTasks2 = dbService.fetchTasks()
        XCTAssert(newTasks2.count==0, "group should be empty")
    }
}
