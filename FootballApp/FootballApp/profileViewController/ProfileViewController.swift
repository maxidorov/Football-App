//
//  ProfileViewController.swift
//  FootballApp
//
//  Created by Anna Lazareva on 17.12.2021.
//

import UIKit

class ProfileViewController: UIViewController, MatchView {
    func matchLoaded() {
        
    }
    
    func statisticLoaded() {
        
    }
    enum Constants {
        static let headerHeight: CGFloat = MatchHeaderView.Constants.height
    }
    
    // add field presenter
    
    var presenter: ProfileViewPresenter!
    
    
    lazy var headerView = ProfileHeaderView()
    private let collectionViewLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    lazy var collectionView: UICollectionView =  {
        collectionViewLayout.minimumLineSpacing = 0
        let view = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        view.backgroundColor = .systemBackground
        return view
    } ()
}
