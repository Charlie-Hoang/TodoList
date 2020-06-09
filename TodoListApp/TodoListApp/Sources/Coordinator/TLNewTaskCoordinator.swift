//
//  TLNewTaskCoordinator.swift
//  TodoListApp
//
//  Created by Charlie on 8/6/20.
//  Copyright © 2020 C. All rights reserved.
//

import UIKit

class TLNewTaskCoordinator: TLCoordinator {
    var childCoordinators = [TLCoordinator]()
    var navigationController: UINavigationController
    weak var parentCoordinator: TLHomeCoordinator?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vm = TLNewTaskViewModel()
        let vc = TLNewTaskVC.instantiate()
        vc.viewModel = vm
        vm.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    func startForEdit(task: Task) {
        let vm = TLNewTaskViewModel(task: task)
        let vc = TLNewTaskVC.instantiate()
        vc.viewModel = vm
        vm.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
}
extension TLNewTaskCoordinator{
    func save(){
        navigationController.popViewController(animated: true)
    }
}
