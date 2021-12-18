//
//  UICollectionViewCell+Separator.swift
//  FootballApp
//
//  Created by Данила on 15.12.2021.
//

import UIKit

extension UICollectionViewCell {
    
    func configureSeparator(_ separator: UIView) {
        separator.frame = CGRect(x: 0,
                                 y: contentView.frame.maxY - 1,
                                 width: contentView.frame.width,
                                 height: 1)
        separator.backgroundColor = .secondaryLabel
    }
}
