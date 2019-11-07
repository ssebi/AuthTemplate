//
//  UIStoryboard+Extensions.swift
//  AuthTemplate
//
//  Created by Sebastian Vidrea on 07/11/2019.
//  Copyright © 2019 AppCompany. All rights reserved.
//

import UIKit

extension UIStoryboard {

    func instantiateViewController<T>(ofType type: T.Type) -> T {
        let identifier = String(describing: type)
        guard let viewController = instantiateViewController(withIdentifier: identifier) as? T else {
            fatalError("Cannot instantiate view controller")
        }
        return viewController
    }

}

// MARK: - All storyboards should be added here.
extension UIStoryboard {

    static let main = UIStoryboard(name: "Main", bundle: nil)

}
