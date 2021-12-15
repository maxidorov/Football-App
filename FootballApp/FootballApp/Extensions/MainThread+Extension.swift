//
//  MainThread+Extension.swift
//  FootballApp
//
//  Created by Gleb Zavyalov on 15.12.2021.
//

import Foundation

func onMainThreadAsync(action: @escaping () -> Void) {
    if Thread.isMainThread {
        action()
        return
    }
    DispatchQueue.main.async {
        action()
    }
}
