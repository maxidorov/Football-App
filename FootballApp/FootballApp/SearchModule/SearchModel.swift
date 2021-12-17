//
//  SearchModel.swift
//  FootballApp
//
//  Created by Данила on 09.12.2021.
//

import UIKit

enum ModelType: Int {
    case player = 1
    case team = 2
    case unknown
}

struct SearchModel {
    let type: ModelType
    
    let id: Int
    let name: String
    var imageURL: String?
    var subscriptonStatus: Bool?
    var description: String?
}

extension SearchModel {
    init?(dict: [String : Any]) {
        guard
            let type = dict["type"],
            let name = dict["name"],
            let id = dict["id"],
            let typeInt = type as? Int,
            let nameStr = name as? String,
            let idInt = id as? Int
        else {
            return nil
        }
        
        
        let imgUrl = dict["imageUrl"] as? String
        let subsStatus = dict["subscriptionStatus"] as? Bool
        let desc = dict["description"] as? String
        
        self.init(
            type: ModelType.init(rawValue: typeInt) ?? .unknown,
            id: idInt,
            name: nameStr,
            imageURL: imgUrl,
            subscriptonStatus: subsStatus,
            description: desc
        )
        
    }
    
    
}

extension SearchModel: Equatable {
    static func == (lhs: SearchModel, rhs: SearchModel) -> Bool {
        lhs.id == rhs.id
    }
}
