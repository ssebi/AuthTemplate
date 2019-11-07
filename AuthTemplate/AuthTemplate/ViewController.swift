//
//  ViewController.swift
//  AuthTemplate
//
//  Created by Sebastian Vidrea on 07/11/2019.
//  Copyright © 2019 AppCompany. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var buttonsStack: UIStackView!
    @IBOutlet weak var primaryButton: UIButton!
    @IBOutlet weak var secondaryButton: UIButton!

    // MARK: - Public Properties
    private var containerViewController: ContainerViewController? {
        ((self.children.first as? UINavigationController)?.viewControllers.first as? ContainerViewController)
    }

    // MARK: - Private Properties

    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Private Functions

    // MARK: - Public Functions
    @IBAction func primaryButtonTapped(_ sender: Any) {
        containerViewController?.goToNextViewController()
    }

    @IBAction func secondaryButtonTapped(_ sender: Any) {
        containerViewController?.goToPreviousViewController()
    }

}

