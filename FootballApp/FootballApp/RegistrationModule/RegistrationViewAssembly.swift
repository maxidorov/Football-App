//
//  RegistrationAssembly.swift
//  FootballApp
//
//  Created by Gleb Zavyalov on 13.12.2021.
//

import Foundation
import UIKit

class RegistrationViewAssembly {
    static func createModule() -> UIViewController {
        let viewController = RegistrationViewController()
        let presenter = RegistrationViewPresenter()

        viewController.registrationViewPresenter = presenter
        presenter.view = viewController

        return viewController
    }
}

