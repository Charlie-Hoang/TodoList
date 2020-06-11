//
//  TaskTests.swift
//  TodoListAppTests
//
//  Created by Charlie on 11/6/20.
//  Copyright © 2020 C. All rights reserved.
//

import XCTest
@testable import TodoListApp
//Task
class TaskTests: XCTestCase {
    let dbService = TLDBService(config: TLDBInMemoryConfiguration.default)
    let ntfService = TLNotificationService()
    func initTasksDB(){
        dbService.deleteAllTasks()
        let task1 = Task(title: "go to work", fireDate: Date())
        task1.finished.value = false
        dbService.createTask(task: task1)
    }
    func testIsRepeat() {
        initTasksDB()
        let task = dbService.fetchTasks().first
        XCTAssertFalse(task!.isRepeat(), "should be false")
        dbService.update(task: task!) {
            task?.repeatType.value = RepeatType.hourly.rawValue
            XCTAssertTrue(task!.isRepeat(), "should be true")
        }
        dbService.deleteAllTasks()
    }
    func testScheduleNotification(){
        initTasksDB()
        let task = dbService.fetchTasks().first
        task?.scheduleNotification()
        TLNotificationService().getPendingNotificationIds { (ids) in
            XCTAssertEqual(ids?.count, 0, "should no notification scheduled")
            self.ntfService.removeAll()
        }
        dbService.update(task: task!) {
            task?.fireDate = Date().add1Day()
            task?.scheduleNotification()
            ntfService.getPendingNotificationIds { (ids) in
                XCTAssertEqual(ids?.count, 1, "should has 1 notification scheduled")
                XCTAssertEqual(ids?.first!, task!.id, "notification id should similar with task id")
                self.ntfService.removeAll()
            }
        }
    }
    func testRemoveNotification(){
        initTasksDB()
        let task = dbService.fetchTasks().first
        dbService.update(task: task!) {
            task?.fireDate = Date().add1Day()
            task?.scheduleNotification()
            task?.removeNotification()
            ntfService.getPendingNotificationIds { (ids) in
                XCTAssertEqual(ids?.count, 0, "should no notification scheduled")
                self.ntfService.removeAll()
            }
        }
    }
    func testProcessScheduleNotification(){
        initTasksDB()
        let task = dbService.fetchTasks().first
        task?.processScheduleNotification()
        TLNotificationService().getPendingNotificationIds { (ids) in
            XCTAssertEqual(ids?.count, 0, "should no notification scheduled")
            self.ntfService.removeAll()
        }
        dbService.update(task: task!) {
            task?.fireDate = Date().add1Day()
            task?.processScheduleNotification()
            ntfService.getPendingNotificationIds { (ids) in
                XCTAssertEqual(ids?.count, 1, "should has 1 notification scheduled")
                XCTAssertEqual(ids?.first!, task!.id, "notification id should similar with task id")
                self.ntfService.removeAll()
            }
        }
    }
}
