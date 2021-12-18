//
//  PlayerCardLabelCell.swift
//  FootballApp
//
//  Created by Данила on 14.12.2021.
//

import UIKit

final class CardLabelCell: UICollectionViewCell {
    
    // MARK: - public properties
    
    static let identifier = "PlayerCardLabelCell"
    
    private let separator = UIView()
    
    // MARK: - private properties
    
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        nameLabel.textAlignment = .center
        nameLabel.textColor = .label
        return nameLabel
    }()
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubviews(nameLabel, separator)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - override
    
    override func layoutSubviews() {
        super.layoutSubviews()
        nameLabel.frame = CGRect(x: 0, y: 0, width: contentView.frame.width * 0.9, height: 50)
        nameLabel.center = contentView.center
    }
}

extension CardLabelCell: CardCellProtocol {
    
    func configure(with model: SearchModel, playerInfo: PlayerInfo?, indexPath: IndexPath?) {
        nameLabel.text = model.name
    }
}
