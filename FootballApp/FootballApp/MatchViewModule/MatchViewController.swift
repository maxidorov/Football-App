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
        collectionViewLayout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        view.backgroundColor = .systemBackground
        view.contentInset = UIEdgeInsets(
            top: 8,
            left: 0,
            bottom: 40,
            right: 0
        )
        return view
    } ()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .secondaryLabel
        indicator.startAnimating()
        return indicator
    }()
    
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
        
        collectionView.register(
            AddToCallendarCell.self,
            forCellWithReuseIdentifier: AddToCallendarCell.Constants.identifier
        )
        

        collectionView.register(
            PubsCell.self,
            forCellWithReuseIdentifier: PubsCell.Constants.identifier
        )
        
        showActivityIndicator()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        layoutHeaderView()
        layoutCollectionView()
        layoutAIndicator()
        collectionViewLayout.invalidateLayout()
    }
    
    private func showActivityIndicator() {
        view.addSubview(activityIndicator)
        collectionView.fadeOut()
    }
    
    private func hideActivityIndicator() {
        activityIndicator.removeFromSuperview()
        collectionView.fadeIn(duration: 0.2)
    }
   
    private func layoutHeaderView() {
        headerView.frame = CGRect(
            x: 0,
            y: -MatchHeaderView.Constants.cornerRadius,
            width: view.frame.width,
            height: MatchHeaderView.Constants.height
        )
    }
    
    private func layoutAIndicator() {
        activityIndicator.center = collectionView.center
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
        1 + max((presenter?.statistics.count ?? 0), (presenter?.match?.startAt?.toDateForm ?? Date() > Date()) ? 2 : 0)

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let statCount = presenter?.statistics.count ?? 0
        
        let makeLastMatchesCell: () -> UICollectionViewCell = {
            guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: LastMatchesCell.Constants.identifier,
            for: indexPath
        ) as? LastMatchesCell else { return UICollectionViewCell() }
            
            if (cell.match == nil) {
                cell.match = self.presenter?.match
            }
            cell.homeTeamColor = self.presenter?.homeTeamColor
            cell.awayTeamColor = self.presenter?.awayTeamColor
            return cell
        }
        
        if (statCount != 0) {
            switch indexPath.row {
            case 0:
                return makeLastMatchesCell()
            case 1..<(1 + (statCount)):
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
        } else if (presenter?.match?.startAt?.toDateForm ?? Date() > Date()){
            switch indexPath.row {
            case 0:
                return makeLastMatchesCell()
            case 1:
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: AddToCallendarCell.Constants.identifier,
                    for: indexPath
                ) as? AddToCallendarCell else { return UICollectionViewCell() }
                cell.match = presenter?.match
                cell.presentAction = { self.present($0, animated: true) }
                return cell

            case 2:
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: PubsCell.Constants.identifier,
                    for: indexPath
                ) as? PubsCell else { return UICollectionViewCell() }
                return cell

            default:
                return UICollectionViewCell()
            }
        } else {
            switch indexPath.row {
            case 0:
                return makeLastMatchesCell()
            default:
                return UICollectionViewCell()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let statCount = presenter?.statistics.count ?? 0
        if statCount != 0 {
            switch indexPath.row {
            case 0:
                return CGSize(width:  collectionView.frame.width, height: LastMatchesCell.Constants.cellHeight)
            case 1..<(1 + statCount):
                return CGSize(width: collectionView.frame.width, height: OneLineStatisticCell.Constants.cellHeight)
            default:
                return CGSize(width: collectionView.frame.width, height: 0)
            }
        }  else if (presenter?.match?.startAt?.toDateForm ?? Date() > Date()) {
            switch indexPath.row {
            case 0:
                return CGSize(width:  collectionView.frame.width, height: LastMatchesCell.Constants.cellHeight)
            case 1:
                return CGSize(width: collectionView.frame.width - LastMatchesCell.Constants.cellMargin * 2, height: AddToCallendarCell.Constants.cellHeight)

            case 2:
                
                return CGSize(
                    width: collectionView.frame.width - LastMatchesCell.Constants.cellMargin * 2,
                    height: (collectionView.frame.width - LastMatchesCell.Constants.cellMargin * 2) / 1.5 + PubsCell.Constants.marginTop)

            default:
                return CGSize(width: collectionView.frame.width, height: 0)
            }
        } else {
            switch indexPath.row {
            case 0:
                return CGSize(width:  collectionView.frame.width, height: LastMatchesCell.Constants.cellHeight)
            default:
                return CGSize(width: collectionView.frame.width, height: 0)
            }
        }
    }
    
    
    
}

protocol MatchView: AnyObject {
    func matchLoaded()
    func statisticLoaded()
}

extension MatchViewController: MatchView {
    
    func statisticLoaded() {
        collectionView.reloadData()
        hideActivityIndicator()
    }
    
    func matchLoaded() {
        headerView.configure(presenter!.match!)
    }
    
}

