//
//  RepeatTypeTests.swift
//  TodoListAppTests
//
//  Created by Charlie on 12/6/20.
//  Copyright © 2020 C. All rights reserved.
//

import XCTest
@testable import TodoListApp

class RepeatTypeTests: XCTestCase {
    func testTriggerComponents(){
        XCTAssertEqual(RepeatType.once.triggerComponents(), [.year,.month,.day,.hour,.minute,.second,], "should be equal")
        XCTAssertEqual(RepeatType.hourly.triggerComponents(), [.minute,.second,], "should be equal")
        XCTAssertEqual(RepeatType.daily.triggerComponents(), [.hour,.minute,.second,], "should be equal")
        XCTAssertEqual(RepeatType.weekly.triggerComponents(), [.weekday,.hour,.minute,.second,], "should be equal")
        XCTAssertEqual(RepeatType.monthly.triggerComponents(), [.day,.hour,.minute,.second,], "should be equal")
        XCTAssertEqual(RepeatType.yearly.triggerComponents(), [.month,.day,.hour,.minute,.second,], "should be equal")
    }
    func testToString(){
        XCTAssertEqual(RepeatType.once.toString(), "Once", "should be equal")
        XCTAssertEqual(RepeatType.hourly.toString(), "Hourly", "should be equal")
        XCTAssertEqual(RepeatType.daily.toString(), "Daily", "should be equal")
        XCTAssertEqual(RepeatType.weekly.toString(), "Weekly", "should be equal")
        XCTAssertEqual(RepeatType.monthly.toString(),"Monthly", "should be equal")
        XCTAssertEqual(RepeatType.yearly.toString(), "Yearly", "should be equal")
    }
    func testToRepeatType(){
        XCTAssertNil((-1).toRepeatType(), "should be nil")
        XCTAssertNil(6.toRepeatType(), "should be nil")
        XCTAssertEqual(0.toRepeatType(), RepeatType.once, "should be equal")
        XCTAssertEqual(1.toRepeatType(), RepeatType.hourly, "should be equal")
        XCTAssertEqual(2.toRepeatType(), RepeatType.daily, "should be equal")
        XCTAssertEqual(3.toRepeatType(), RepeatType.weekly, "should be equal")
        XCTAssertEqual(4.toRepeatType(), RepeatType.monthly, "should be equal")
        XCTAssertEqual(5.toRepeatType(), RepeatType.yearly, "should be equal")
    }
}
