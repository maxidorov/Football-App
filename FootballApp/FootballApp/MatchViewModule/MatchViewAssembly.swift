//
//  MatchViewAssembly.swift
//  FootballApp
//
//  Created by Gleb Zavyalov on 13.12.2021.
//

import UIKit

class MatchViewAssembly {
    static func createModule() -> MatchViewController {
        let viewController = MatchViewController()
        let presenter = MatchViewPresenter()

        viewController.presenter = presenter
        presenter.view = viewController

        return viewController
    }
}
