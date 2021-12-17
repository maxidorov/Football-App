//
//  PlayerInfo.swift
//  FootballApp
//
//  Created by Данила on 17.12.2021.
//

import Foundation

struct PlayerInfo: Codable {
    let positionName: String
    let weight, age: Int
    let dateBirthAt: String
    var height: Double
    let shirtNumber: Int
    let flag: String

    enum CodingKeys: String, CodingKey {
        case positionName = "position_name"
        case weight, age
        case dateBirthAt = "date_birth_at"
        case height, flag
        case shirtNumber = "shirt_number"
    }
}
