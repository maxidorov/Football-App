//
//  RequestIdentifier.swift
//  FootballApp
//
//  Created by Gleb Zavyalov on 09.12.2021.
//

import Foundation

protocol RequestIdentifier {
    var id: Int { get }
    static var requestComponent: String { get }
}

