//
//  MatchStatisticsView.swift
//  FootballApp
//
//  Created by Gleb Zavyalov on 14.12.2021.
//

import UIKit
import UIImageColors

class LastMatchesCell: UICollectionViewCell {
    enum Constants {
        static let identifier = "LastMatchesCell"
        static let cellMargin: CGFloat = 10
        static let cellSpace: CGFloat = 12
        static let cellHeight: CGFloat = 170
    }
    
    override var reuseIdentifier: String? {
        Constants.identifier
    }
    
    var homeTeamColor: UIImageColors?
    var awayTeamColor: UIImageColors?
    
    var match: Match? {
        didSet {
            guard let match = match else { return }
            network.getMatches(
                by1: match.homeTeam,
                by2: match.awayTeam, completion: { [weak self]
                    result in
                    switch result {
                    case.success(let matches):
                        self?.matches = self?.filterMatches(matches) ?? []
                        onMainThreadAsync {
                            self?.collectionView.reloadData()
                        }
                    case .failure:
                        break
                    }
                })
        }
    }
    
    lazy var network = Network()
    var matches = [Match]()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(
            width: frame.width,
            height: Constants.cellHeight
        )
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = Constants.cellSpace * 2
        layout.itemSize = CGSize(
            width: (frame.width - 2 * Constants.cellMargin) / 3,
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
        
        collectionView.register(MiniMatchCell.self, forCellWithReuseIdentifier: MiniMatchCell.Constants.identifier)
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
    
    private func filterMatches(_ arrayOfMatches: [Match]) -> [Match] {
        var arrMatches: [Match] = []
        arrMatches = arrayOfMatches.sorted(by: { (a, b) in
            return a.startAt ?? "" > b.startAt ?? ""})
        
        arrMatches = arrMatches.filter{ a in a.id != (match?.id ?? 0) }
        
        return arrMatches
    }
}


extension LastMatchesCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        matches.count

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MiniMatchCell.Constants.identifier, for: indexPath) as? MiniMatchCell else {
            return UICollectionViewCell()
        }
        cell.homeTeamColor = homeTeamColor
        cell.awayTeamColor = awayTeamColor
        cell.match = matches[indexPath.row]

        return cell
    }
}
