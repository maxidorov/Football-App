//
//  Match.swift
//  FootballApp
//
//  Created by Gleb Zavyalov on 09.12.2021.
//

import Foundation

struct Match: Decodable {
    let id: Int
    let name: String?
    let homeTeam: Team
    let awayTeam: Team
    let status: String?
    let startAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, status
        case homeTeam = "home_team"
        case awayTeam = "away_team"
        case startAt = "start_at"
    }
}

extension Match: Hashable {
    static func == (lhs: Match, rhs: Match) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}


