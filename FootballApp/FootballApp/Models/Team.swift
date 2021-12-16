//
//  Team.swift
//  FootballApp
//
//  Created by Gleb Zavyalov on 09.12.2021.
//

import Foundation

struct Team: Decodable {
    let id: Int
    let name: String
    let shortName: String?
    let hasLogo: Bool
    let logo: String?
    
    
    enum CodingKeys: String, CodingKey {
        case id, name, logo
        case shortName = "name_short"
        case hasLogo = "has_logo"
        
    }
}

extension Team: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Team: Equatable {
    static func == (lhs: Team, rhs: Team) -> Bool {
        lhs.id == rhs.id
    }
}

extension Team: RequestIdentifier {
    static var requestComponent: String {
        Network.EndpointComponent.teams.value
    }
}

extension Team {
    init(id: Int) {
        self.init(
            id: id,
            name: "",
            shortName: nil,
            hasLogo: false,
            logo: nil
        )
    }
}

