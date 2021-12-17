//
//  MatchHeaderView.swift
//  FootballApp
//
//  Created by Gleb Zavyalov on 13.12.2021.
//

import UIKit

class MatchHeaderView: UIView {
    enum Constants {
        static let cornerRadius: CGFloat = 20
        static let height: CGFloat = 150 + cornerRadius
        static let matchCellMargin: CGFloat = cornerRadius
    }
    
    var configurationModel: Match?
    
    
    lazy var firstTeamImageView: UIImageView = makeTeamImageView()
    
    lazy var secondTeamImageView: UIImageView = makeTeamImageView()
    
    lazy var firstTeamLabel: UILabel = makeTeamLabel()
    
    lazy var secondTeamLabel: UILabel = makeTeamLabel()
    
    private lazy var timeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        timeLabel.textAlignment = .center
        timeLabel.adjustsFontSizeToFitWidth = true
        timeLabel.minimumScaleFactor = 0.5
        return timeLabel
    }()
    
    private lazy var dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        dateLabel.textAlignment = .center
        dateLabel.adjustsFontSizeToFitWidth = true
        dateLabel.minimumScaleFactor = 0.5
        return dateLabel
    }()
    
    private lazy var scoreLabel: UILabel = {
        let scoreLabel = UILabel()
        scoreLabel.font = UIFont.systemFont(ofSize: 50, weight: .regular)
        scoreLabel.textAlignment = .center
        scoreLabel.adjustsFontSizeToFitWidth = true
        return scoreLabel
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews(
            scoreLabel,
            firstTeamLabel,
            secondTeamLabel,
            firstTeamImageView,
            secondTeamImageView,
            timeLabel,
            dateLabel
        )
        
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = Constants.cornerRadius
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("MatchHeaderView init(coder: )")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        layoutTeamLabels()
        layoutImageLabels()
        layoutScoreLabel()
        layoutTimeLabel()
        layoutDateLabel()
    }
    
    // MARK: - Public methods
    
    func configure(_ withModel: Match) {
        configurationModel = withModel
        
        firstTeamImageView.image = UIImage()
        secondTeamImageView.image = UIImage()
        
        loadImage(withModel.homeTeam.logo, completion: { image in
            self.firstTeamImageView.image = image ?? UIImage()
        })
        
        loadImage(withModel.awayTeam.logo, completion: { image in
            self.secondTeamImageView.image = image ?? UIImage()
        })
        
        firstTeamLabel.text = withModel.homeTeam.shortName ?? withModel.name
        secondTeamLabel.text = withModel.awayTeam.shortName ?? withModel.name
        
        withModel.startAt.map {
            timeLabel.text = $0.toDate
            dateLabel.text = $0.toDate
        }
        
        scoreLabel.text = MatchCell.Constants.scoreLabelPlaceholder
        if
            let homeScore = withModel.homeScore?.display,
            let awayScore = withModel.awayScore?.display {
            scoreLabel.text = "\(homeScore) : \(awayScore)"
        }
    }
    
    private func loadImage(_ with: String?, completion: @escaping(UIImage?) -> Void) {
        ImageLoader.shared.loadImage(with: with, completion: { result in
            switch result  {
            case .success(let image):
                DispatchQueue.main.async {
                    completion(image)
                }
            case .failure(_):
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        })
    }
    
    // MARK: - Private methods
    
    private func makeTeamImageView() -> UIImageView {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        imageView.clipsToBounds = true
        return imageView
    }
    
    private func makeTeamLabel() -> UILabel {
        let teamLabel = UILabel()
        teamLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        teamLabel.textAlignment = .center
        teamLabel.textColor = UIColor.gray
        return teamLabel
    }
    
    private func layoutImageLabels() {
        let quoterHeight = 75
        
        firstTeamImageView.frame = CGRect(origin: .zero, size: CGSize(width: quoterHeight, height: quoterHeight))
        secondTeamImageView.frame = CGRect(origin: .zero, size: CGSize(width: quoterHeight, height: quoterHeight))
        
        firstTeamImageView.center = CGPoint(
            x: center.x / 2,
            y: center.y + 20
        )
        secondTeamImageView.center = CGPoint(
            x: center.x * 1.5,
            y: center.y + 20
        )
    }
    
    private func layoutScoreLabel() {
        scoreLabel.frame = CGRect(
            origin: .zero,
            size: CGSize(
                width: secondTeamImageView.frame.minX - firstTeamImageView.frame.maxX - 10,
                height: firstTeamImageView.frame.height
            )
            
        )
        scoreLabel.center = CGPoint(x: center.x, y: firstTeamImageView.center.y)
    }
    
    private func layoutTimeLabel() {
        timeLabel.frame = CGRect(
            origin: .zero,
            size: CGSize(width: frame.width / 8, height: 12)
        )
        timeLabel.center = CGPoint(
            x: center.x,
            y: firstTeamImageView.frame.minY + 0.05 * bounds.height
        )
    }
    
    private func layoutDateLabel() {
        dateLabel.frame = CGRect(
            origin: .zero,
            size: CGSize(width: frame.width / 8, height: 12)
        )
        dateLabel.center = CGPoint(
            x: center.x,
            y: firstTeamImageView.frame.maxY + 0.01 * bounds.height
        )
    }
    
    private func layoutTeamLabels() {
        firstTeamLabel.frame = CGRect(
            x: firstTeamImageView.center.x,
            y: firstTeamImageView.center.y,
            width: firstTeamImageView.frame.width * 2,
            height: 20
        )
        secondTeamLabel.frame = CGRect(
            x: secondTeamImageView.center.x,
            y: secondTeamImageView.center.y,
            width: secondTeamImageView.frame.width * 2,
            height: 20
        )
        
        let firstTeamLabelCenter = CGPoint(
            x: firstTeamImageView.center.x,
            y: firstTeamImageView.frame.maxY + 0.12 * bounds.height
        )
        let secondTeamLabelCenter = CGPoint(
            x: secondTeamImageView.center.x,
            y: secondTeamImageView.frame.maxY + 0.12 * bounds.height
        )
        firstTeamLabel.center = firstTeamLabelCenter
        secondTeamLabel.center = secondTeamLabelCenter
    }
    
  
    
}
