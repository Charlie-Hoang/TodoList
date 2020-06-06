//
//  TLCoordinator.swift
//  TodoListApp
//
//  Created by Charlie on 6/6/20.
//  Copyright © 2020 C. All rights reserved.
//

import UIKit

protocol TLCoordinator {
    var childCoordinators: [TLCoordinator] { get set }
    var navigationController: UINavigationController { get set }

    func start()
}
