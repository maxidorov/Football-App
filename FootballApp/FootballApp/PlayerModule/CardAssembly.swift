//
//  PlayerCardAssembly.swift
//  FootballApp
//
//  Created by Данила on 14.12.2021.
//

import UIKit

final class CardAssembly {
    static func createCardModule(with model: CardModel) -> UIViewController {
        let viewController = CardViewController()
        let presenter = CardPresenter(model: model)
        
        viewController.presenter = presenter
        presenter.view = viewController
        
        return viewController
    }
}
