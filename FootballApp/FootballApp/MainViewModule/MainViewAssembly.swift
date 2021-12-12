//
//  MainViewAssembly.swift
//  FootballApp
//
//  Created by Gleb Zavyalov on 10.12.2021.
//

import Foundation

class MainViewAssembly {
    static func createModule() -> MainViewController {
        let viewController = MainViewController()
        let presenter = MainViewPresenter()

        viewController.mainViewPresenter = presenter
        presenter.view = viewController

        return viewController
    }
}
