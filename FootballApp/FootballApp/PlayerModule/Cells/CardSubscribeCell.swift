//
//  PlayerCardSubscribeCell.swift
//  FootballApp
//
//  Created by Данила on 15.12.2021.
//

import UIKit

final class CardSubscribeCell: UICollectionViewCell {
    
    // MARK: - public properties
    
    static let identifier = "PlayerCardSubscribeCell"
    
    private let separator = UIView()
    
    lazy var subscribeButton: UIButton = {
        let subscribeButton = UIButton(type: .system)
        subscribeButton.frame = CGRect(x: 0, y: 0, width: 150, height: 50)
        subscribeButton.layer.cornerRadius = 20
        subscribeButton.setTitle("Subscribe", for: .normal)
        subscribeButton.setTitleColor(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), for: .normal)
        subscribeButton.backgroundColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
        return subscribeButton
    }()
    
    // MARK: - override
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubviews(subscribeButton, separator)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        subscribeButton.center = contentView.center
        configureSeparator(separator)
    }
}

extension CardSubscribeCell: CardCellProtocol {
    func configure(with model: CardModel) {
        guard let status = model.subscriptonStatus else { return }
        updateCell(with: status)
    }
}

extension CardSubscribeCell: CellUpdaterProtocol {
    func updateCell(with subscribe: Bool) {
        if subscribe {
            subscribeButton.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
            subscribeButton.setTitle("Unsubscribe", for: .normal)
        } else {
            subscribeButton.backgroundColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
            subscribeButton.setTitle("Subscribe", for: .normal)
        }
    }
}
