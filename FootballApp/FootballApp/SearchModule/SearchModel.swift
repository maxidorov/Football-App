//
//  SearchModel.swift
//  FootballApp
//
//  Created by Данила on 09.12.2021.
//

import UIKit

enum ModelType {
    case player
    case team
    case unkown
}

struct SearchModel {
    let type: ModelType
    
    let id: Int
    let name: String
    var imageURL: String?
}
