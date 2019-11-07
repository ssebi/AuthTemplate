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
    lazy private var nameViewController: NameViewController = {
        return UIStoryboard.main.instantiateViewController(ofType: NameViewController.self)
    }()

    lazy private var emailViewController: EmailViewController = {
        return UIStoryboard.main.instantiateViewController(ofType: EmailViewController.self)
    }()

    lazy private var phoneViewController: PhoneViewController = {
        return UIStoryboard.main.instantiateViewController(ofType: PhoneViewController.self)
    }()

    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    // MARK: - Private Functions

    // MARK: - Public Functions

}
