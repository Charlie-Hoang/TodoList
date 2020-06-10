//
//  BaseVC.swift
//  TodoListApp
//
//  Created by Charlie on 6/6/20.
//  Copyright © 2020 C. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BaseVC: UIViewController, TLStoryboarded{
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

// MARK: SETUP NavigationBar
extension BaseVC{
    @objc func back() {
        self.navigationController?.popViewController(animated: true);
    }
    @objc func save() {
        
    }
    @objc func category() {
        
    }
    @objc func sort() {
        
    }
    func showBackButton() {
        self.navigationItem.leftBarButtonItem = createBarButton(title: "Cancel", image: nil, selector: #selector(back))
    }
    func showSaveButton(){
        self.navigationItem.rightBarButtonItem = createBarButton(title: "Save", image: nil, selector: #selector(save))
    }
    func showLabelButton(){
        self.navigationItem.leftBarButtonItem = createBarButton(title: "All labels", image: nil, selector: #selector(category))
    }
    func showSortButton(){
        self.navigationItem.rightBarButtonItem = createBarButton(title: "Sort", image: nil, selector: #selector(sort))
    }
    func createBarButton(title: String?, image: UIImage?, selector: Selector) -> UIBarButtonItem{
        let _button = UIButton(type: .custom)
        _button.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
        _button.setBackgroundImage(image, for: .normal)
        _button.setTitle(title, for: .normal)
        _button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17.0)
        _button.setTitleColor(UIColor.white, for: .normal)
        _button.addTarget(self, action: selector, for: .touchUpInside)
        return UIBarButtonItem(customView: _button)
    }
}
