//
//  SearchRequestRespone.swift
//  FootballApp
//
//  Created by Gleb Zavyalov on 09.12.2021.
//

import Foundation

struct SearchRequestResponse<T: Decodable>: Decodable {
    let data: T
}
