//
//  UINavigationController+Extensions.swift
//  AuthTemplate
//
//  Created by Sebastian Vidrea on 07/11/2019.
//  Copyright © 2019 AppCompany. All rights reserved.
//

import UIKit

public extension UINavigationController {

    /**
     Pop current view controller.

     - parameter type:     transition animation type.
     - parameter subtype:  transition subtype.
     - parameter duration: transition animation duration.
     */
    func pop(transitionType type: CATransitionType, subtype: CATransitionSubtype, duration: CFTimeInterval = 0.3) {
        self.addTransition(transitionType: type, subtype: subtype, duration: duration)
        self.popViewController(animated: false)
    }

    /**
     Push a new view controller on the view controllers's stack.

     - parameter viewController:       view controller to push.
     - parameter type:     transition animation type.
     - parameter subtype:  transition subtype.
     - parameter duration: transition animation duration.
     */
    func push(viewController: UIViewController, transitionType type: CATransitionType, subtype: CATransitionSubtype, duration: CFTimeInterval = 0.3) {
        self.addTransition(transitionType: type, subtype: subtype, duration: duration)
        self.pushViewController(viewController, animated: false)
    }

    // MARK: - Private
    private func addTransition(transitionType type: CATransitionType, subtype: CATransitionSubtype, duration: CFTimeInterval = 0.3) {
        let transition = CATransition()
        transition.duration = duration
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = type
        transition.subtype = subtype
        self.view.layer.add(transition, forKey: nil)
    }

}
