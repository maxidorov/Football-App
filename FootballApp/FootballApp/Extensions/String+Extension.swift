//
//  String+Extension.swift
//  FootballApp
//
//  Created by Gleb Zavyalov on 11.12.2021.
//

import Foundation

extension String {
    var url: URL? {
        URL(string: self)
    }
}

extension Optional where Wrapped == String {
    var url: URL? {
        URL(string: self ?? "")
    }
}
