//
//  RootViewController.swift
//  FootballApp
//
//  Created by Gleb Zavyalov on 08.12.2021.
//

import UIKit

class RootViewController: UITabBarController {
    private var mainViewController: UIViewController = {
        let vc = MainViewAssembly.createModule()
        vc.title = MainViewController.Constants.tabBarTitle
        return vc
    } ()
  
    private var searchViewController: UIViewController = {
        let vc = SearchAssembly.createSearchModule()
        vc.title = SearchViewController.Constants.tabBarTitle
        return vc
    }()
    
    private var profileViewController: UIViewController = {
        let vc = ProfileViewAssembly.createModule()
        vc.title = "Title"
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setViewControllers([mainViewController, searchViewController, profileViewController], animated: false)
        guard let items = self.tabBar.items else { return }
        for i in 0...2 {
            items[i].image = UIImage(systemName: ["house", "magnifyingglass", "person.crop.circle"][i])
        }
        items.last?.title = "Profile"
        self.tabBar.tintColor = .systemBlue
    }
}

extension RootViewController: UITabBarControllerDelegate {
    
}
