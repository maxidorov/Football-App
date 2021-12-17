//
//  UIActivityIndicatorView+Extension.swift
//  FootballApp
//
//  Created by Gleb Zavyalov on 17.12.2021.
//

import UIKit

extension UIActivityIndicatorView {
    
    func makeIndicator() -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .secondaryLabel
        indicator.startAnimating()
        return indicator
    }
    
}
