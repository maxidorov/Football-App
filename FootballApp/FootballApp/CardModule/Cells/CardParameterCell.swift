//
//  CardParameterCell.swift
//  FootballApp
//
//  Created by Данила on 17.12.2021.
//

import UIKit

final class CardParameterCell: UICollectionViewCell {
    
    // MARK: - public properties
    
    static let identifier = "CardParameterCell"
    
    private let separator = UIView()
    
    // MARK: - private properties
    
    private lazy var infoLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 19, weight: .regular)
        nameLabel.textAlignment = .left
        nameLabel.textColor = .black
        return nameLabel
    }()
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubviews(infoLabel, separator)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - override
    
    override func layoutSubviews() {
        super.layoutSubviews()
        infoLabel.frame = CGRect(x: 0, y: 0, width: contentView.frame.width * 0.9, height: 40)
        infoLabel.center = contentView.center
        configureSeparator(separator)
    }
}

extension CardParameterCell: CardCellProtocol {
    
    func configure(with model: SearchModel, playerInfo: PlayerInfo?, indexPath: IndexPath?) {
        guard let playerInfo = playerInfo else { return }
        switch indexPath?.row {
        case 3:
            infoLabel.text = "Position".addTabs(6) + playerInfo.positionName
        case 4:
            infoLabel.text = "Country".addTabs(6) + playerInfo.flag.capitalized
        case 5:
            infoLabel.text = "Age".addTabs(7) + "\(playerInfo.age)"
        case 6:
            infoLabel.text = "Birthday".addTabs(6) + playerInfo.dateBirthAt.replacingOccurrences(of: "-", with: ".")
        case 7:
            let height = (playerInfo.height * 100).rounded() / 100
            infoLabel.text = "Height".addTabs(6) + "\(height) m"
        case 8:
            infoLabel.text = "Weight".addTabs(6) + "\(playerInfo.weight)"
        case 9:
            infoLabel.text = "Number".addTabs(6) + "\(playerInfo.shirtNumber)"
        default:
            return
        }
    }
}
