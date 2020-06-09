//
//  TLHomeCellViewModel.swift
//  TodoListApp
//
//  Created by Charlie on 8/6/20.
//  Copyright © 2020 C. All rights reserved.
//

import Foundation

protocol TLTaskCellPresentable {
    var title: String?{get}
    var fireDate: String?{get}
    var label: String?{get}
    var isRepeat: Bool{get}
    var isPendingNotification: Bool{get}
}
struct TLTaskCellViewModel: TLTaskCellPresentable{
    var model: Task
    var title: String?{return model.title}
    var fireDate: String?{return model.fireDate?.tlString()}
    var label: String?{return model.label?.title}
    var isRepeat: Bool{return model.isRepeat()}
    var isPendingNotification: Bool{return model.pendingNotification}
    init(task: Task){
        self.model = task
    }
    func check(){
        TLDBService().update(task: model) {
            model.finished.value = !(model.finished.value ?? false)
        }
    }
}
