//
//  ContainerViewController.swift
//  AuthTemplate
//
//  Created by Sebastian Vidrea on 07/11/2019.
//  Copyright © 2019 AppCompany. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {
    // MARK: - IBOutlets

    // MARK: - Public Properties

    // MARK: - Private Properties
    enum AuthViewControllers {
        case name
        case email
        case phone

        func initial() -> UIViewController {
            switch self {
                case .name:
                    return UIStoryboard.main.instantiateViewController(ofType: NameViewController.self)
                case .email:
                    return UIStoryboard.main.instantiateViewController(ofType: EmailViewController.self)
                case .phone:
                    return UIStoryboard.main.instantiateViewController(ofType: PhoneViewController.self)
            }
        }

        mutating func next() -> UIViewController {
            switch self {
                case .name:
                    self = .email
                    return UIStoryboard.main.instantiateViewController(ofType: EmailViewController.self)
                case .email:
                    self = .phone
                    return UIStoryboard.main.instantiateViewController(ofType: PhoneViewController.self)
                case .phone:
                    self = .name
                    return UIStoryboard.main.instantiateViewController(ofType: NameViewController.self)
            }
        }
    }

    private var currentViewController: AuthViewControllers = .name

    // MARK: - ViewController Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.pushViewController(currentViewController.initial(), animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Private Functions

    // MARK: - Public Functions
    func goToNextViewController() {
        navigationController?.push(viewController: currentViewController.next(), transitionType: .push, subtype: .fromRight)
    }

    func goToPreviousViewController() {
        navigationController?.pop(transitionType: .push, subtype: .fromLeft)
    }

}
