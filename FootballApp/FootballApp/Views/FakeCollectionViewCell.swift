//
//  FakeCollectionViewCell.swift
//  FootballApp
//
//  Created by Gleb Zavyalov on 08.12.2021.
//

import UIKit

class FakeCollectionViewCell: UICollectionViewCell {
    static let identifier = "FakeCell"
    static let cellHeight: CGFloat = 50
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "tt"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let viewSubviews: [UIView] = [
            label
        ]
        for v in viewSubviews { contentView.addSubview(v) }
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.frame = CGRect(
            x: 5, y: 0,
            width: contentView.bounds.width - 10, height: 20
        )
    }
    
    public func configure(text: String) {
        label.text = text
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
    }
}
