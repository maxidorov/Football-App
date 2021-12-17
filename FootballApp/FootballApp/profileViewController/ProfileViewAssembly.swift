//
//  ProfileViewAssembly.swift
//  FootballApp
//
//  Created by Anna Lazareva on 17.12.2021.
//

import UIKit

class ProfileViewAssembly {
    static func createModule() -> ProfileViewController {
        let viewController = ProfileViewController()
        let presenter = ProfileViewPresenter()
        viewController.presenter = presenter
        viewController.title = "Title"
        presenter.view = viewController
//        presenter.match = model

        return viewController
    }
}
