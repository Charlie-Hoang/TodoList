//
//  SortType.swift
//  TodoListApp
//
//  Created by Charlie on 10/6/20.
//  Copyright © 2020 C. All rights reserved.
//

import Foundation
enum SortType: Int{
    case createDate = 0
    case fireDate = 1
    case title = 2
    func toString() -> String{
        switch self {
        case .createDate:
            return "Create Date"
        case .fireDate:
            return "Remind Date"
        case .title:
            return "Title"
        }
    }
    func sort(tasks: [Task]) -> [Task]{
        if case .fireDate = self{
            return sortByFireDate(tasks: tasks)
        }
        if case .title = self{
            return sortByTitle(tasks: tasks)
        }
        return tasks
    }
}
extension SortType{
    private func sortByFireDate(tasks: [Task]) -> [Task]{
        return tasks.sorted { (t1, t2) -> Bool in
            return t1.fireDate! <= t2.fireDate!
        }
    }
    private func sortByTitle(tasks: [Task]) -> [Task]{
        return tasks.sorted { (t1, t2) -> Bool in
            return t1.title! <= t2.title!
        }
    }
}
extension Int{
    func toSortType() -> SortType?{
        if self >= SortType.createDate.rawValue && self <= SortType.title.rawValue{
            return SortType(rawValue: self)
        }
        return nil
    }
}
