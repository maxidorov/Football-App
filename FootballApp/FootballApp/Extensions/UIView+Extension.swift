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

extension UIView {

  func fadeIn(duration: TimeInterval = 0.3,
              delay: TimeInterval = 0.0,
              completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in }) {
    UIView.animate(withDuration: duration,
                   delay: delay,
                   options: UIView.AnimationOptions.curveEaseIn,
                   animations: {
      self.alpha = 1.0
    }, completion: completion)
  }

  func fadeOut(duration: TimeInterval = 0.3,
               delay: TimeInterval = 0.0,
               completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in }) {
    UIView.animate(withDuration: duration,
                   delay: delay,
                   options: UIView.AnimationOptions.curveEaseIn,
                   animations: {
      self.alpha = 0.0
    }, completion: completion)
  }
}
