//
//  RootViewController.swift
//  FootballApp
//
//  Created by Gleb Zavyalov on 08.12.2021.
//

import UIKit

class RootViewController: UITabBarController {
    private enum Constants {
        static let mainVCTitle: String = "Matches"
        static let searchVCTitle: String = "Search"
    }
    
    lazy var mainViewController: UIViewController = {
        let vc = MainViewController()
        vc.title = Constants.mainVCTitle
        return vc
    } ()
    lazy var searchViewController: UIViewController = {
        let vc = SearchViewController()
        vc.title = Constants.searchVCTitle
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        self.setViewControllers([mainViewController, searchViewController], animated: false)
        guard let items = self.tabBar.items else { return }
        for i in 0...1 {
            items[i].image = UIImage(systemName: ["house", "magnifyingglass"][i])
        }
        self.tabBar.tintColor = .systemBlue
    }

}

extension RootViewController: UITabBarControllerDelegate {
    
}
