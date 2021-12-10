//
//  NetworkProtocol.swift
//  FootballApp
//
//  Created by Gleb Zavyalov on 09.12.2021.
//

import Foundation

protocol NetworkProtocol {
    func search<T>(item: T.Type,  withName: String, completionHandler: @escaping (Result<[T], Error>) -> Void) where T: (Decodable & RequestIdentifier)
    func searchMatches(byTeam: Team, completionHandler: @escaping (Result<[Match], Error>) -> Void)
    func searchMatches(byPlayer: Player, completionHandler: @escaping (Result<[Match], Error>) -> Void)
    func searchTeams(byPlayer: Player, completionHandler: @escaping (Result<[Team], Error>) -> Void)
    func searchMatches<T>(by: [T], completionHandler: @escaping (Result<[Match], Error>) -> Void)
}
