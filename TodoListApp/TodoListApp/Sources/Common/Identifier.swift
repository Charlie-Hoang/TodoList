//
//  Identifier.swift
//  TodoListApp
//
//  Created by Charlie on 8/6/20.
//  Copyright © 2020 C. All rights reserved.
//

import Foundation
import UIKit

protocol Identifier {
    static var identifier: String{get}
}
extension Identifier{
    static var identifier: String {
        return String(describing: self)
    }
}
extension UIView: Identifier{}
extension UITableView{
    func regCell<CellName>(cell: CellName) where CellName: UITableViewCell{
        self.register(UINib(nibName: CellName.identifier, bundle: nil),
                      forCellReuseIdentifier: CellName.identifier)
    }
}
