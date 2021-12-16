//
//  MatchFac.swift
//  FootballApp
//
//  Created by Gleb Zavyalov on 16.12.2021.
//

import Foundation

struct MatchFact: Decodable {
    let id: Int
    let eventId: Int
    let teamBase: String?
    let name: String?
    let value: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, name, value
        case eventId = "event_id"
        case teamBase = "team_base"
        
    }
}
