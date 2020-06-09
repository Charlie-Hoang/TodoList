//
//  UIView+Ext.swift
//  TodoListApp
//
//  Created by Charlie on 9/6/20.
//  Copyright © 2020 C. All rights reserved.
//

import UIKit

extension UIView{
    func removeSubviews(){
        subviews.forEach{$0.removeFromSuperview()}
//        for subview in self.subviews{
//            subview.removeFromSuperview()
//        }
    }
    
    enum LTAnimation {
        case pushFromRight
        case pushFromLeft
        case pushFromTop
        case pushFromBottom
    }
    func makeLTAnimation(animationType: LTAnimation){
        switch animationType {
        case .pushFromLeft:
            let transition = CATransition()
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromLeft
            self.layer.add(transition, forKey: nil)
        case .pushFromRight:
            let transition = CATransition()
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromRight
            self.layer.add(transition, forKey: nil)
        case .pushFromTop:
            let transition = CATransition()
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromTop
            self.layer.add(transition, forKey: nil)
        case .pushFromBottom:
            let transition = CATransition()
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromBottom
            self.layer.add(transition, forKey: nil)
        }
    }
}
