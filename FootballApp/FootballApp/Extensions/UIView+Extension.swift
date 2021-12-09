//
//  UIView+Extension.swift
//  check
//
//  Created by Данила on 09.12.2021.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView ...) {
        views.forEach { (view) in
            self.addSubview(view)
        }
    }
}
