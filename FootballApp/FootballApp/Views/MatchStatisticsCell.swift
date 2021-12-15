//
//  MatchStatisticsView.swift
//  FootballApp
//
//  Created by Gleb Zavyalov on 14.12.2021.
//

import UIKit
import UIImageColors

class MatchStatisticsViewCell: UICollectionViewCell {
    enum Constants {
        static let identifier = "MatchStatisticsViewCellId"
        static let cellMargin: CGFloat = 10
        static let cellSpace: CGFloat = 12
        static let cellHeight: CGFloat = 120
    }
    
    override var reuseIdentifier: String? {
        Constants.identifier
    }
    
    var homeTeamColor: UIImageColors?
    var awayTeamColor: UIImageColors?
    
    var parentCollectionView: UICollectionView?
    
    var match: Match? {
        didSet {
            guard let match = match else { return }
            network.getStatics(by: match.id, completion: { [weak self]
                result in
                onMainThreadAsync {
                    switch result {
                    case .success(let stats):
                        debugPrint(stats)
                        self?.statistics = stats
                        self?.collectionView.reloadData()
                    case .failure(_):
                        break
                    }
                }
            })
        }
    }
    
    lazy var network = Network()
    var statistics = [StatisticUnit]()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(
            width: frame.width,
            height: Constants.cellHeight
        )
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = Constants.cellSpace * 2
        layout.itemSize = CGSize(
            width: (frame.width - 2 * Constants.cellMargin) / 2,
            height: frame.height - 2 * Constants.cellMargin
        )
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .systemBackground
        view.contentInset = UIEdgeInsets(
            top: 0,
            left: 2 * Constants.cellMargin,
            bottom: 0,
            right: 2 * Constants.cellMargin
        )
        return view
    } ()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        debugPrint("trying to init")
        
        addSubviews(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(StatisticUnitCell.self, forCellWithReuseIdentifier: StatisticUnitCell.Constants.identifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionViewLayout()
    }
    
    func collectionViewLayout() {
        collectionView.frame = CGRect(
            origin: .zero,
            size: CGSize(
                width: frame.width,
                height: Constants.cellHeight
            )
        )
    }
}


extension MatchStatisticsViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        statistics.count
//        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StatisticUnitCell.Constants.identifier, for: indexPath) as? StatisticUnitCell else {
            return UICollectionViewCell()
        }
        cell.homeTeamColor = homeTeamColor
        cell.awayTeamColor = awayTeamColor
        cell.statModel = statistics[indexPath.row]

        return cell
    }
}
