//
//  TLLabelInHomeViewModel.swift
//  TodoListApp
//
//  Created by Charlie on 9/6/20.
//  Copyright © 2020 C. All rights reserved.
//

import Foundation

protocol TLLabelInHomePresentable {
    var title: String?{get}
    var selected: Bool?{get}
}
struct TLLabelInHomeViewModel: TLLabelInHomePresentable{
    var model: Label
    var title: String?{return model.title}
    var selected: Bool?
    init(label: Label){
        self.model = label
        selected = false
    }
}
