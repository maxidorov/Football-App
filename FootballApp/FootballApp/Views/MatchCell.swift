//
//  MatchCell.swift
//  check
//
//  Created by Данила on 08.12.2021.
//

import UIKit


final class MatchCell: UICollectionViewCell {
    enum Constants {
        static let cellHeight: CGFloat = 150
        static let identifier = "MatchCell"
        static let dateLabelPlaceholder = "--/--/--"
        static let timeLabelPlaceholder = "--:--"
        static let scoreLabelPlaceholder = "- : -"
    }
    
    
    // MARK: - public properties
    
    
    lazy var firstTeamImageView: UIImageView = makeTeamImageView()
    
    lazy var secondTeamImageView: UIImageView = makeTeamImageView()
    
    lazy var firstTeamLabel: UILabel = makeTeamLabel()
    
    lazy var secondTeamLabel: UILabel = makeTeamLabel()
        
    var configurationModel: Match? = nil
    
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
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubviews(
            firstTeamImageView,
            secondTeamImageView,
            firstTeamLabel,
            secondTeamLabel,
            timeLabel,
            dateLabel,
            scoreLabel
        )
        
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = 20
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layoutImageLabels()
        layoutTeamLabels()
        layoutDateLabel()
        layoutScoreLabel()
        layoutTimeLabel()
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
        timeLabel.text = withModel.startAt?.toTime
        dateLabel.text = withModel.startAt?.toDate
        
        scoreLabel.text = Constants.scoreLabelPlaceholder
        if
            let homeScore = withModel.homeScore?.display,
            let awayScore = withModel.awayScore?.display {
            scoreLabel.text = "\(homeScore) : \(awayScore)"
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        firstTeamImageView.image = UIImage()
        secondTeamImageView.image = UIImage()
        
        ImageLoader.shared.cancelLoad(by: configurationModel?.homeTeam.logo)
        ImageLoader.shared.cancelLoad(by: configurationModel?.awayTeam.logo)
        firstTeamLabel.text = nil
        secondTeamLabel.text = nil
        dateLabel.text = nil
        scoreLabel.text = nil
    }
    
    // MARK: - Private methods
    
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
    
    // MARK: - Private methods: UI
    
    private func layoutImageLabels() {
        let quoterHeight = contentView.bounds.height / 2
        firstTeamImageView.frame = CGRect(origin: .zero, size: CGSize(width: quoterHeight, height: quoterHeight))
        secondTeamImageView.frame = CGRect(origin: .zero, size: CGSize(width: quoterHeight, height: quoterHeight))
        
        firstTeamImageView.center = CGPoint(
            x: contentView.center.x / 2,
            y: contentView.center.y - 20
        )
        secondTeamImageView.center = CGPoint(
            x: contentView.center.x * 1.5,
            y: contentView.center.y - 20
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
            y: firstTeamImageView.frame.maxY + 0.2 * contentView.bounds.height
        )
        let secondTeamLabelCenter = CGPoint(
            x: secondTeamImageView.center.x,
            y: secondTeamImageView.frame.maxY + 0.2 * contentView.bounds.height
        )
        firstTeamLabel.center = firstTeamLabelCenter
        secondTeamLabel.center = secondTeamLabelCenter
    }
    
    
    private func layoutTimeLabel() {
        timeLabel.frame = CGRect(
            origin: .zero,
            size: CGSize(width: contentView.frame.width / 8, height: 12)
        )
        timeLabel.center = CGPoint(
            x: contentView.center.x,
            y: firstTeamImageView.frame.minY + 0.05 * contentView.bounds.height
        )
    }
    
    private func layoutDateLabel() {
        dateLabel.frame = CGRect(
            origin: .zero,
            size: CGSize(width: contentView.frame.width / 8, height: 12)
        )
        dateLabel.center = CGPoint(
            x: contentView.center.x,
            y: firstTeamImageView.frame.maxY + 0.1 * contentView.bounds.height
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
        scoreLabel.center = CGPoint(x: contentView.center.x, y: firstTeamImageView.center.y)
    }
    
    private func makeTeamImageView() -> UIImageView {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        imageView.clipsToBounds = true
        return imageView
    }
    
    func makeTeamLabel() -> UILabel {
        let teamLabel = UILabel()
        teamLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        teamLabel.textAlignment = .center
        teamLabel.textColor = UIColor.gray
        return teamLabel
    }
}
