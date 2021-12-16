//
//  StatisticUnitCell.swift
//  FootballApp
//
//  Created by Gleb Zavyalov on 14.12.2021.
//

import UIKit
import UIImageColors

class MiniMatchCell: UICollectionViewCell {
    enum Constants {
        static let identifier = "StatisticUnitCellId"
        static let cornerRadius: CGFloat = 12
        static let defaultCellMargins: CGFloat = 10
        static let defaultImageSize: CGFloat = 34
    }
    
    var homeTeamColor: UIImageColors?
    var awayTeamColor: UIImageColors?
            
    private lazy var homeImageView: UIImageView = makeImageView()
    private lazy var awayImageView: UIImageView = makeImageView()
    private lazy var homeTeamLabel: UILabel = makeLabel()
    private lazy var awayTeamLabel: UILabel = makeLabel()
    private lazy var homeScoreLabel: UILabel = makeScoreLabel()
    private lazy var awayScoreLabel: UILabel = makeScoreLabel()
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    var match: Match? {
        didSet {
            if (match != nil) {
                configure()
                loadImages()
            }
        }
    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .secondarySystemBackground
        addSubviews(
            homeTeamLabel,
            awayTeamLabel,
            homeImageView,
            awayImageView,
            homeScoreLabel,
            awayScoreLabel,
            dateLabel
        )
        
        layer.cornerRadius = Constants.cornerRadius
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dateLabelLayout()
        imagesLayout()
        labelsLayout()
    }
    
    private func makeImageView() -> UIImageView {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        imageView.clipsToBounds = true
        return imageView
    }
    
    private func configure() {
        dateLabel.text = (match?.startAt ?? "").toDate
        homeTeamLabel.text = match?.homeTeam.shortName
        awayTeamLabel.text = match?.awayTeam.shortName
        homeScoreLabel.text = "\(match?.homeScore?.current ?? 0)"
        awayScoreLabel.text = "\(match?.awayScore?.current ?? 0)"
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        ImageLoader.shared.cancelLoad(by: match?.homeTeam.logo)
        ImageLoader.shared.cancelLoad(by: match?.awayTeam.logo)
}
    
    
    private func loadImages() {
        ImageLoader.shared.loadImage(with: match?.homeTeam.logo, completion: {
            result in
            switch result {
            case .success(let image):
                onMainThreadAsync {
                    self.homeImageView.image = image
                }
            case .failure:
                break
            }
        })
        
        ImageLoader.shared.loadImage(with: match?.awayTeam.logo, completion: {
            result in
            switch result {
            case .success(let image):
                onMainThreadAsync {
                    self.awayImageView.image = image
                }
            case .failure:
                break
            }
        })

    }
    
    private func dateLabelLayout() {
        dateLabel.frame = CGRect(
            x: Constants.defaultCellMargins,
            y: Constants.defaultCellMargins,
            width: frame.width / 2.5, height: 20
        )
    }
    
    private func labelsLayout() {
        homeTeamLabel.frame = CGRect(
            x: Constants.defaultCellMargins,
            y: homeImageView.frame.maxY + Constants.defaultCellMargins,
            width: frame.width - 3 * Constants.defaultCellMargins,
            height: 20
        )
        awayTeamLabel.frame = CGRect(
            x: Constants.defaultCellMargins,
            y: homeTeamLabel.frame.maxY,
            width: frame.width - 3 * Constants.defaultCellMargins,
            height: 20
        )
        
        homeScoreLabel.frame = CGRect(
            origin: .zero,
            size: CGSize(
                width: 10, height: 20
            )
        )
        
        awayScoreLabel.frame = CGRect(
            origin: .zero,
            size: CGSize(
                width: 10, height: 20
            )
        )
        
        homeScoreLabel.frame.origin = CGPoint(
            x: frame.width - 10 - Constants.defaultCellMargins,
            y: homeTeamLabel.frame.minY
        )
        awayScoreLabel.frame.origin = CGPoint(
            x: frame.width - 10 - Constants.defaultCellMargins,
            y: awayTeamLabel.frame.minY
        )
        
    }
    
    private func makeLabel() -> UILabel {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.font = .boldSystemFont(ofSize: 13)
        label.textColor = .gray
        return label
    }
    
    private func makeScoreLabel() -> UILabel {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }
    
    private func imagesLayout() {
        homeImageView.frame = CGRect(
            x: Constants.defaultCellMargins,
            y: dateLabel.frame.maxY + Constants.defaultCellMargins * 2,
            width: Constants.defaultImageSize,
            height: Constants.defaultImageSize
        )
        
        awayImageView.frame = CGRect(
            x: homeImageView.frame.maxX + Constants.defaultCellMargins,
            y: dateLabel.frame.maxY + Constants.defaultCellMargins * 2,
            width: Constants.defaultImageSize,
            height: Constants.defaultImageSize
        )
    }
    
}
