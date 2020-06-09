//
//  TLVC.swift
//  TodoListApp
//
//  Created by Charlie on 8/6/20.
//  Copyright © 2020 C. All rights reserved.
//

import Foundation
protocol TLVC: class {
    
    associatedtype ViewModelType
    
    var viewModel: ViewModelType! { get set }
    
}
