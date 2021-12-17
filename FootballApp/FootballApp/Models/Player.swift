//
//  Player.swift
//  FootballApp
//
//  Created by Gleb Zavyalov on 09.12.2021.
//

import Foundation

struct Player: Decodable {
    let id: Int
    let name: String
    let shortName: String?
    let hasPhoto: Bool
    let photo: String?
    let age: Int?
    let position: String?
    let positionName: String?
    let flag: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, photo, age, position, flag
        case shortName = "name_short"
        case hasPhoto = "has_photo"
        case positionName = "position_name"
    }
}

extension Player: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Player: RequestIdentifier {
    static var requestComponent: String {
        Network.EndpointComponent.players.value
    }
}

extension Player: Equatable {
    static func == (lhs: Player, rhs: Player) -> Bool {
        lhs.id == rhs.id
    }
}

extension Player {
    init(id: Int) {        
        self.init(
            id: id,
            name: "",
            shortName: nil,
            hasPhoto: false,
            photo: nil,
            age: nil,
            position: nil,
            positionName: nil, flag: nil
        )
    }
}
