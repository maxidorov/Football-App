//
//  UICollectionViewCell+Separator.swift
//  FootballApp
//
//  Created by Данила on 15.12.2021.
//

import UIKit

extension UICollectionViewCell {
    
    func configureSeparator(_ separator: UIView) {
        separator.frame = CGRect(x: 20,
                                 y: contentView.frame.maxY - 1,
                                 width: contentView.frame.width - 20,
                                 height: 1)
        separator.backgroundColor = #colorLiteral(red: 0.9085107446, green: 0.9056906104, blue: 0.9107233882, alpha: 1)
    }
}
