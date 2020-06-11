//
//  TLHomeCoordinator.swift
//  TodoListApp
//
//  Created by Charlie on 8/6/20.
//  Copyright © 2020 C. All rights reserved.
//

import UIKit

class TLHomeCoordinator: NSObject, TLCoordinator, UINavigationControllerDelegate {
    var childCoordinators = [TLCoordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        
    }
    func start() {
        self.navigationController.delegate = self
        let vm = TLHomeViewModel()
        let vc = TLHomeVC.instantiate()
        vc.viewModel = vm
        vm.coordinator = self
        navigationController.popToRootViewController(animated: false)
        navigationController.pushViewController(vc, animated: false)
    }
    
}
extension TLHomeCoordinator{
    func newTask(){
        let child = TLNewTaskCoordinator(navigationController: navigationController)
        child.parentCoordinator = self
        childCoordinators.append(child)
        print("childCoorNew: \(childCoordinators.count)")
        child.start()
    }
    func editTask(task: Task){
        let child = TLNewTaskCoordinator(navigationController: navigationController)
        child.parentCoordinator = self
        childCoordinators.append(child)
        print("childCoorEdit: \(childCoordinators.count)")
        child.startForEdit(task: task)
    }
    func reFetchData(){
        let vc = navigationController.viewControllers.last as? TLHomeVC
        vc?.fetchData()
    }
    
    func childDidFinish(_ child: TLCoordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }

    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        // Read the view controller we’re moving from.
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }

        // Check whether our view controller array already contains that view controller. If it does it means we’re pushing a different view controller on top rather than popping it, so exit.
        if navigationController.viewControllers.contains(fromViewController) {
            return
        }

        // We’re still here – it means we’re popping the view controller, so we can check whether it’s a buy view controller
        if let newTaskVC = fromViewController as? TLNewTaskVC {
            // We're popping a buy view controller; end its coordinator
            childDidFinish(newTaskVC.viewModel.coordinator)
        }
    }
}
