//
//  SearchModel.swift
//  FootballApp
//
//  Created by Данила on 09.12.2021.
//

import UIKit

enum SearchModelType {
    case player
    case team
}

struct SearchModel {
    let type: SearchModelType
    
    let id: Int
    let name: String
}
