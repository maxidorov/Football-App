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
    
    
    lazy var headerView = MatchHeaderView()
    private let collectionViewLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    lazy var collectionView: UICollectionView =  {
        collectionViewLayout.minimumLineSpacing = 0
        let view = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        view.backgroundColor = .systemBackground
        return view
    } ()
    
    var presenter: MatchViewPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        view.addSubviews(
            headerView,
            collectionView
        )
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            LastMatchesCell.self,
            forCellWithReuseIdentifier: LastMatchesCell.Constants.identifier
        )
        
        collectionView.register(
            OneLineStatisticCell.self,
            forCellWithReuseIdentifier: OneLineStatisticCell.Constants.identifier
        )
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        layoutHeaderView()
        layoutCollectionView()
    }
    
   
    private func layoutHeaderView() {
        headerView.frame = CGRect(
            x: 0,
            y: -MatchHeaderView.Constants.cornerRadius,
            width: view.frame.width,
            height: MatchHeaderView.Constants.height
        )
    }
    
    private func layoutCollectionView() {
        collectionView.frame = CGRect(
            x: 0,
            y: headerView.frame.maxY,
            width: view.frame.width,
            height: view.frame.height - headerView.frame.height
        )
    }
    
}

extension MatchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1 + (presenter?.statistics.count ?? 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: LastMatchesCell.Constants.identifier,
                for: indexPath
            ) as? LastMatchesCell else { return UICollectionViewCell() }
            
            if (cell.match == nil) {
                cell.match = presenter?.match
            }
            cell.homeTeamColor = presenter?.homeTeamColor
            cell.awayTeamColor = presenter?.awayTeamColor
            return cell
                
        case 1..<(1 + (presenter?.statistics.count ?? 0)):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: OneLineStatisticCell.Constants.identifier,
                for: indexPath
            ) as? OneLineStatisticCell else { return UICollectionViewCell() }
            cell.awayTeamColor = presenter?.awayTeamColor
            cell.homeTeamColor = presenter?.homeTeamColor
            cell.statModel = presenter?.statistics[indexPath.row - 1]
            return cell
            
        default:
            return UICollectionViewCell()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.row == 0 {
            return CGSize(width: view.frame.width, height: LastMatchesCell.Constants.cellHeight)
        }
        
        if indexPath.row >= 1 {
            return CGSize(width: view.frame.width, height: OneLineStatisticCell.Constants.cellHeight)
        }
        
        return CGSize(width: view.frame.width, height: 0)
    }
    
}

protocol MatchView: AnyObject {
    func matchLoaded()
    func statisticLoaded()
}

extension MatchViewController: MatchView {
    func statisticLoaded() {
        self.collectionView.reloadData()
    }
    
    func matchLoaded() {
        headerView.configure(presenter!.match!)
    }
    
}

