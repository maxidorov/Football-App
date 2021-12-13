//
//  MatchViewController.swift
//  FootballApp
//
//  Created by Gleb Zavyalov on 13.12.2021.
//

import UIKit

class MatchViewController: UIViewController {
    enum Constants {
        static let headerHeight: CGFloat = MatchHeaderView.Constants.height
    }
    
    var match: Match? {
        didSet {
            if (match != nil) {
                headerView.configure(match!)
            }
        }
    }
    
    lazy var headerView = MatchHeaderView()
    
    var presenter: MatchViewPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubviews(
            headerView
        )
        
        view.backgroundColor = .systemBackground
    }
    
    override func viewWillLayoutSubviews() {
        layoutHeaderView()
    }
    
    private func layoutHeaderView() {
        headerView.frame = CGRect(
            x: 0,
            y: -MatchHeaderView.Constants.cornerRadius,
            width: view.frame.width,
            height: MatchHeaderView.Constants.height
        )
    }
    
}

protocol MatchView: AnyObject {
    
}

extension MatchViewController: MatchView {
    
}

