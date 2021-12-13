//
//  UIViewController+Extension.swift
//  FootballApp
//
//  Created by Gleb Zavyalov on 13.12.2021.
//

import UIKit

extension UIViewController {
    func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
}
