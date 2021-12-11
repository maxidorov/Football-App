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
        return vc
    } ()
  
    private var searchViewController: UIViewController = {
        let vc = SearchViewController()
        vc.title = "Search"
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let apiK = KeychainService.getDataFromKeychainByKey(key: "api-key") {
            print(String(decoding: apiK, as: UTF8.self))
        }
        
        view.backgroundColor = .systemBackground
        setViewControllers([mainViewController, searchViewController], animated: false)
        guard let items = self.tabBar.items else { return }
        for i in 0...1 {
            items[i].image = UIImage(systemName: ["house", "magnifyingglass"][i])
        }
        self.tabBar.tintColor = .systemBlue
    }
}

extension RootViewController: UITabBarControllerDelegate {
    
}
