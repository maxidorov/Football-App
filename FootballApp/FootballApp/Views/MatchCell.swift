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
    }
    
    // MARK: - public properties
    
    
    lazy var firstTeamImageView: UIImageView = makeTeamImageView()
    
    lazy var secondTeamImageView: UIImageView = makeTeamImageView()
    
    lazy var firstTeamLabel: UILabel = makeTeamLabel()
    
    lazy var secondTeamLabel: UILabel = makeTeamLabel()
    
    lazy var imageLoader: ImageLoader = ImageLoader()
    
    var configurationModel: Match? = nil
    
    lazy var dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.font = UIFont.systemFont(ofSize: 10, weight: .light)
        dateLabel.textAlignment = .center
        dateLabel.adjustsFontSizeToFitWidth = true
        dateLabel.minimumScaleFactor = 0.5
        dateLabel.textColor = .black
        return dateLabel
    }()
    
    lazy var scoreLabel: UILabel = {
        let scoreLabel = UILabel()
        scoreLabel.font = UIFont.systemFont(ofSize: 50, weight: .regular)
        scoreLabel.textAlignment = .center
        scoreLabel.textColor = .black
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
        dateLabel.text = withModel.startAt
        scoreLabel.text = "2 : 0"
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        firstTeamImageView.image = UIImage()
        secondTeamImageView.image = UIImage()
        
        imageLoader.cancelLoad(by: configurationModel?.homeTeam.logo)
        imageLoader.cancelLoad(by: configurationModel?.awayTeam.logo)
        firstTeamLabel.text = nil
        secondTeamLabel.text = nil
        dateLabel.text = nil
        scoreLabel.text = nil
    }
    
    // MARK: - Private methods
    
    private func layoutImageLabels() {
        let quoterHeight = contentView.bounds.height / 2
        firstTeamImageView.frame = CGRect(x: 0, y: 0, width: quoterHeight, height: quoterHeight)
        secondTeamImageView.frame = CGRect(x: 0, y: 0, width: quoterHeight, height: quoterHeight)
        
        firstTeamImageView.layer.cornerRadius = firstTeamImageView.bounds.height / 2
        secondTeamImageView.layer.cornerRadius = secondTeamImageView.bounds.height / 2
        
        firstTeamImageView.center = CGPoint(
            x: contentView.center.x / 2,
            y: contentView.center.y - 20
        )
        secondTeamImageView.center = CGPoint(
            x: contentView.center.x * 1.5,
            y: contentView.center.y - 20
        )
    }
    
    private func loadImage(_ with: String?, completion: @escaping(UIImage?) -> Void) {
        imageLoader.loadImage(with: with, completion: { result in
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
    
    private func layoutDateLabel() {
        dateLabel.frame = CGRect(
            origin: CGPoint(x: 0, y: 0),
            size: CGSize(width: contentView.frame.width / 8, height: 12)
        )
        dateLabel.center = CGPoint(
            x: contentView.center.x,
            y: firstTeamImageView.frame.maxY + 0.1 * contentView.bounds.height
        )
    }
    
    private func layoutScoreLabel() {
        scoreLabel.frame = CGRect(
            x: 0, y: 0,
            width: secondTeamImageView.frame.minX - firstTeamImageView.frame.maxX - 10,
            height: firstTeamImageView.frame.height
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
