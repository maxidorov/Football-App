//
//  PlayerCardImageCell.swift
//  FootballApp
//
//  Created by Данила on 14.12.2021.
//

import UIKit

final class CardImageCell: UICollectionViewCell {
    
    // MARK: - public properties
    
    static let identifier = "PlayerCardImageCell"
    
    private let separator = UIView()
    
    // MARK: - private properties
    
    private lazy var photoView: UIImageView = {
        let photoView = UIImageView(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: CardCellSizes.imageHeight.rawValue - 10,
                                                  height: CardCellSizes.imageHeight.rawValue - 10))
        photoView.backgroundColor = .gray
        photoView.clipsToBounds = true
        photoView.layer.cornerRadius = 10
        return photoView
    }()
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubviews(photoView, separator)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - override
    
    override func layoutSubviews() {
        super.layoutSubviews()
        photoView.center = contentView.center
        configureSeparator(separator)
    }
}

// MARK: - PlayerCardCellProtocol

extension CardImageCell: CardCellProtocol {
    func configure(with model: CardModel) {
        DispatchQueue.global().async {
            ImageLoader.shared.loadImage(with: model.imageURL) { (result) in
                switch result {
                    case .success(let image):
                        DispatchQueue.main.async {
                            self.photoView.image = image
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                }
            }
        }
    }
}
