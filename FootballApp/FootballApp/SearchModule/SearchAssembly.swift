//
//  SearchAssembly.swift
//  FootballApp
//
//  Created by Данила on 10.12.2021.
//

import UIKit

class SearchAssembly {
    static func createSearchModule() -> UIViewController {
        let viewController = SearchViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        let presenter = SearchPresenter(network:  Network())
        
        viewController.presenter = presenter
        presenter.view = viewController
        
        return navigationController
    }
}
