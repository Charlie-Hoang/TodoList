//
//  TLHomeCoordinator.swift
//  TodoListApp
//
//  Created by Charlie on 8/6/20.
//  Copyright © 2020 C. All rights reserved.
//

import UIKit

class TLHomeCoordinator: TLCoordinator {
    var childCoordinators = [TLCoordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    func start() {
        let vm = TLHomeViewModel()
        let vc = TLHomeVC.instantiate()
        vc.viewModel = vm
        vm.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
}
extension TLHomeCoordinator{
    func newTask(){
        let child = TLNewTaskCoordinator(navigationController: navigationController)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start()
    }
    func editTask(task: Task){
        let child = TLNewTaskCoordinator(navigationController: navigationController)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.startForEdit(task: task)
    }
}
