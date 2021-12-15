//
//  OneLineStatisticCell.swift
//  FootballApp
//
//  Created by Gleb Zavyalov on 15.12.2021.
//

import UIKit
import UIImageColors

class OneLineStatisticCell: UICollectionViewCell {
    enum Constants {
        static let identifier = "OneLineStatisticUnitCellId"
        static let cellVerticalMargin: CGFloat = 8
        static let cellHorizantalMargin: CGFloat = 30
        static let cellHeight: CGFloat = 40
        
    }
    
    var homeTeamColor: UIImageColors?
    var awayTeamColor: UIImageColors?

    var statModel: StatisticUnit? {
        didSet {
            configure()
        }
    }
    
    lazy var homeStatLabel: UILabel = makeStatLabel()
    lazy var awayStatLabel: UILabel = makeStatLabel()

    
    lazy var statNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        label.textColor = .gray
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        
        addSubviews(
            statNameLabel,
            homeStatLabel,
            awayStatLabel
        )
        
        
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        statNameLabelLayout()
        statLabelLayout()
    }
    
    private func configure() {
        guard let statModel = statModel else { return }

        statNameLabel.text = (statModel.name ?? "").formatStatName()
        homeStatLabel.text = (statModel.home ?? "").formatStatName()
        awayStatLabel.text = statModel.away ?? ""
        
        
        switch statModel.compareCode {
        case 1:
            homeStatLabel.textColor = .black
            awayStatLabel.textColor = .lightGray
        case 2:
            homeStatLabel.textColor = .lightGray
            awayStatLabel.textColor = .black
        default:
            homeStatLabel.textColor = .black
            awayStatLabel.textColor = .black
        }
        
    }
    
    
    func makeStatLabel() -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        label.adjustsFontSizeToFitWidth = true
        label.clipsToBounds = true
        return label
    }
    
    func statLabelLayout() {
        homeStatLabel.frame = CGRect(
            origin: .zero,
            size: CGSize(
                width: frame.width / 6,
                height: Constants.cellHeight - 2 * Constants.cellVerticalMargin
            )
        )
        
        homeStatLabel.frame.origin = CGPoint(
            x: Constants.cellHorizantalMargin,
            y: Constants.cellVerticalMargin
        )
        
        awayStatLabel.frame = CGRect(
            origin: .zero,
            size: CGSize(
                width: frame.width / 6,
                height: Constants.cellHeight - 2 * Constants.cellVerticalMargin
            )
        )
        
        awayStatLabel.frame.origin = CGPoint(
            x: frame.width - awayStatLabel.frame.width - Constants.cellHorizantalMargin,
            y: Constants.cellVerticalMargin
        )
    }
    
    
    func statNameLabelLayout() {
        statNameLabel.frame = CGRect(
            origin: .zero,
            size: CGSize(
                width: frame.width / 2,
                height: Constants.cellHeight - 2 * Constants.cellVerticalMargin
            )
        )
        statNameLabel.frame.origin = CGPoint(
            x: frame.width / 2 - statNameLabel.frame.width / 2,
            y: Constants.cellVerticalMargin
        )
    }
}
