//
//  StatisticUnit.swift
//  FootballApp
//
//  Created by Gleb Zavyalov on 14.12.2021.
//

import Foundation

struct StatisticUnit: Decodable {
    let id: Int
    let eventId: Int
    let group: String?
    let name: String?
    let away: String?
    let home: String?
    let compareCode: Int?

    enum CodingKeys: String, CodingKey {
        case id, group, name, away, home
        case eventId = "event_id"
        case compareCode = "compare_code"
    }
}

extension StatisticUnit: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}

extension StatisticUnit: Equatable {
  static func ==(lhs: StatisticUnit, rhs: StatisticUnit) -> Bool {
    return lhs.name == rhs.name
  }
}
