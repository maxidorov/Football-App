//
//  StatisticUnitCell.swift
//  FootballApp
//
//  Created by Gleb Zavyalov on 14.12.2021.
//

import UIKit
import UIImageColors

class StatisticUnitCell: UICollectionViewCell {
    enum Constants {
        static let identifier = "StatisticUnitCellId"
        static let cornerRadius: CGFloat = 12
        static let defaultCellMargins: CGFloat = 10
    }
    
    var homeTeamColor: UIImageColors? {
        didSet {
            guard let homeTeamColor = homeTeamColor else {
                return
            }
            onMainThreadAsync {
                self.statNameLabel.textColor = homeTeamColor.background ?? .systemBackground
            }
        }
    }
    var awayTeamColor: UIImageColors? {
        didSet {
            guard let awayTeamColor = awayTeamColor else {
                return
            }
            onMainThreadAsync {
                self.backgroundColor = awayTeamColor.background ?? .systemBackground
            }
        }
    }

    
    var statModel: StatisticUnit? {
        didSet {
            if (statModel != nil) {
                configure()
            }
        }
    }
    
    lazy var statNameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(statNameLabel)

        layer.cornerRadius = Constants.cornerRadius
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        statNameLabelLayout()
    }
    
    private func configure() {
        statNameLabel.text = statModel?.name ?? ""
        
    }
    
    
    func statNameLabelLayout() {
        statNameLabel.frame = CGRect(
            x: Constants.defaultCellMargins, y: Constants.defaultCellMargins,
            width: frame.width - 2 * Constants.defaultCellMargins, height: 30
        )
    }
}
