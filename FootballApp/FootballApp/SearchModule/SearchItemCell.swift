//
//  SearchItemCell.swift
//  FootballApp
//
//  Created by Данила on 10.12.2021.
//

import UIKit

final class SearchItemCell: UICollectionViewCell {
    
    private enum Constants {
        enum Appearance {
            // Colors
            static let backgroundColor: UIColor = #colorLiteral(red: 0.9724641442, green: 0.9726034999, blue: 0.9724336267, alpha: 1)
            
            // Layout
            static let imageViewCornerRadius: CGFloat = 5
            static let contentViewCornerRadius: CGFloat = 10
            static let titleMargins: CGFloat = 12
        }
    }
    
    // MARK: - public properties
    
    static let identifier: String = "SearchItemCell"
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont(name: "Helvetica-Light", size: 20)
        return titleLabel
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
        
        contentView.addSubviews(titleLabel, imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.frame = CGRect(
            x: Constants.Appearance.titleMargins,
            y: Constants.Appearance.titleMargins,
            width: contentView.frame.width * 0.7,
            height: 22
        )
        
        
        imageView.frame = CGRect(
            origin: .zero,
            size: CGSize(
                width: 30,
                height: 30
            )
        )
        imageView.center = CGPoint(
            x: contentView.frame.maxX - 30,
            y: contentView.center.y
        )
    }
    
    override func prepareForReuse() {
        titleLabel.text = nil
        imageView.image = nil
        ImageLoader.shared.cancelLoad(by: model?.imageURL)
    }
    
    // MARK: - Public methods
    
    func configureWithModel(model: SearchModel) {
        self.model = model
        titleLabel.text = model.name
        
        ImageLoader.shared.loadImage(with: model.imageURL) { (result) in
            switch result {
                case .success(let image):
                    DispatchQueue.main.async {
                        self.imageView.image = image
                    }
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
}
