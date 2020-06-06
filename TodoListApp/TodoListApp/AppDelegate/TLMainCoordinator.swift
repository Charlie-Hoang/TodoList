//
//  TLMainCoordinator.swift
//  TodoListApp
//
//  Created by Charlie on 6/6/20.
//  Copyright © 2020 C. All rights reserved.
//

import UIKit

class TLMainCoordinator: TLCoordinator {
    var childCoordinators = [TLCoordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = TLHomeVC.instantiate()
        navigationController.pushViewController(vc, animated: false)
    }
}
