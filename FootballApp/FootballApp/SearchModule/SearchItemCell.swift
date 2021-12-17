//
//  SearchItemCell.swift
//  FootballApp
//
//  Created by Данила on 10.12.2021.
//

import UIKit

final class SearchItemCell: UICollectionViewCell {
    
    enum Constants {
        enum Appearance {
            // Colors
            static let backgroundColor: UIColor = .secondarySystemBackground
            
            // Layout
            static let imageViewCornerRadius: CGFloat = 5
            static let contentViewCornerRadius: CGFloat = 12
            static let titleMargins: CGFloat = 12
            static let imageViewSize: CGFloat = 40
            
            static let cellMargins: CGFloat = 12
            static let cellHeight: CGFloat = imageViewSize + 2 * cellMargins
        }
    }
    
    // MARK: - public properties
    
    static let identifier: String = "SearchItemCell"
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        return titleLabel
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Constants.Appearance.imageViewCornerRadius
        return imageView
    }()
    
    // MARK: - private properties
    
    private var model: SearchModel?
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = Constants.Appearance.backgroundColor
        contentView.layer.cornerRadius = Constants.Appearance.contentViewCornerRadius
        contentView.addSubviews(titleLabel, imageView, descriptionLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.frame = CGRect(
            origin: .zero,
            size: CGSize(
                width: Constants.Appearance.imageViewSize,
                height: Constants.Appearance.imageViewSize
            )
        )
        imageView.frame.origin = CGPoint(
            x: Constants.Appearance.cellMargins,
            y: Constants.Appearance.cellMargins
        )
        
        titleLabel.frame = CGRect(
            origin: .zero,
            size: CGSize(
                width: contentView.frame.width * 0.7,
                height: 22
            )
        )
        
        titleLabel.frame.origin = CGPoint(
            x: imageView.frame.maxX + Constants.Appearance.cellMargins,
            y: Constants.Appearance.cellMargins
        )
        
        descriptionLabel.frame = CGRect(
            x: titleLabel.frame.minX,
            y: titleLabel.frame.maxY,
            width: contentView.frame.width, height: 18
        )

    }
    
    override func prepareForReuse() {
        titleLabel.text = nil
        descriptionLabel.text = nil
        imageView.image = nil
        ImageLoader.shared.cancelLoad(by: model?.imageURL)
    }
    
    // MARK: - Public methods
    
    func configureWithModel(model: SearchModel) {
        self.model = model
        switch model.type {
        case .team:
            self.imageView.layer.cornerRadius = Constants.Appearance.imageViewCornerRadius
        case .player:
            self.imageView.layer.cornerRadius = Constants.Appearance.imageViewSize / 2
        default:
            break
        }
        
        titleLabel.text = model.name
        descriptionLabel.text = (model.description ?? "").captializeFirst()
        
        ImageLoader.shared.loadImage(with: model.imageURL) { (result) in
            onMainThreadAsync {
                switch result {
                case .success(let image):
                    self.imageView.image = image
                case .failure:
                    switch model.type {
                    case .team:
                        self.imageView.layer.cornerRadius = Constants.Appearance.imageViewCornerRadius
                        self.imageView.image = UIImage(systemName: "person.3")?.withTintColor(.gray, renderingMode: .alwaysOriginal)
                    case .player:
                        self.imageView.layer.cornerRadius = Constants.Appearance.imageViewSize / 2
                        self.imageView.image = UIImage(systemName: "person")?.withTintColor(.gray, renderingMode: .alwaysOriginal)
                    default:
                        break
                    }
                }
            }
        }
    }
}
