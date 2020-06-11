//
//  SortTypeTests.swift
//  TodoListAppTests
//
//  Created by Charlie on 12/6/20.
//  Copyright © 2020 C. All rights reserved.
//

import XCTest
@testable import TodoListApp
//Task
class SortTypeTests: XCTestCase {
    func testToString(){
        XCTAssertEqual(SortType.createDate.toString(),"Create Date", "should be equal")
        XCTAssertEqual(SortType.fireDate.toString(), "Remind Date", "should be equal")
        XCTAssertEqual(SortType.title.toString(), "Title", "should be equal")
    }
    func testSort(){
        let task1 = Task(title: "work", fireDate: Date())
        let task2 = Task(title: "eat", fireDate: Date().add1Day())
        let task3 = Task(title: "sleep", fireDate: Date())
        let tasks = [task1, task2, task3]
        XCTAssertEqual(SortType.createDate.sort(tasks: tasks), [task1, task2, task3], "should be equal")
        XCTAssertEqual(SortType.fireDate.sort(tasks: tasks),[task1, task3, task2], "should be equal")
        XCTAssertEqual(SortType.title.sort(tasks: tasks), [task2, task3, task1], "should be equal")
    }
}
