//
//  Cell.swift
//  TodoListApp
//
//  Created by Charlie on 8/6/20.
//  Copyright © 2020 C. All rights reserved.
//

import Foundation

//base protocol
protocol CellPresentable {
    
}


protocol CellConfigurable {
    associatedtype Presenter
    func configCell(presenter: Presenter)
}
