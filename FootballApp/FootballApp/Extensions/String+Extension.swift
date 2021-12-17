//
//  String+Extension.swift
//  FootballApp
//
//  Created by Gleb Zavyalov on 11.12.2021.
//

import Foundation


let globalDateFormatter = DateFormatter()

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

extension String {
    var toDate: String {
        globalDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        globalDateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        guard let date = globalDateFormatter.date(from: self) else {
            return MatchCell.Constants.dateLabelPlaceholder
        }
        globalDateFormatter.dateFormat = "dd/MM/YY"
        globalDateFormatter.timeZone = .current
        return globalDateFormatter.string(from: date)
    }
    
    var toDateNoYear: String {
        globalDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        globalDateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        guard let date = globalDateFormatter.date(from: self) else {
            return MatchCell.Constants.dateLabelPlaceholder
        }
        globalDateFormatter.dateFormat = "dd/MM"
        globalDateFormatter.timeZone = .current
        return globalDateFormatter.string(from: date)
    }
    
    var toTime: String {
        globalDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        globalDateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        guard let date = globalDateFormatter.date(from: self) else {
            return MatchCell.Constants.timeLabelPlaceholder
        }
        globalDateFormatter.dateFormat = "HH:mm"
        globalDateFormatter.timeZone = .current
        return globalDateFormatter.string(from: date)
    }
    
    func formatStatName() -> String {
        var name = self
        name = name.replacingOccurrences(of: "_", with: " ")
        return String(name.prefix(1)).capitalized + String(name.dropFirst())
    }
    
    func captializeFirst() -> String {
        return String(self.prefix(1)).capitalized + String(self.dropFirst())
    }
}
