//
//  Network.swift
//  FootballApp
//
//  Created by Gleb Zavyalov on 09.12.2021.
//

import Foundation
import UIKit

class Network: NetworkProtocol {
    public enum Constants {
        static let headers = [
            "x-rapidapi-host": "sportscore1.p.rapidapi.com",
            "x-rapidapi-key": "c9b4cb4ee8msh962972f210927cep135288jsn196736e1ed38"
        ]
        static let host: String = "football-pro.p.rapidapi.com"
        static let apiKey: String = "c9b4cb4ee8msh962972f210927cep135288jsn196736e1ed38"
        static let domainUrl: String = "https://sportscore1.p.rapidapi.com"
        static let sportId: String = "1"
    }
    private typealias Const = Constants
    
    enum EndpointComponent: String {
        case teams
        case players
        case search
        case events

        var value: String {
            "/\(rawValue)"
        }
    }
    
    enum RequestType: String {
        case get
        case post

        var value: String {
            rawValue.uppercased()
        }
    }

    private func request<T: Decodable>(_ urlString: String, method: RequestType, completion: @escaping(Result<[T], Error>) -> Void) {
        makeRequest(urlString, method: method, type: [T].self) { result in
            switch result {
            case .success(let obj):
                completion(.success(obj))
            case .failure(let err):
                return completion(.failure(err))
            }
        }
    }
    
    func search<T>(item: T.Type, withName: String, completion: @escaping (Result<[T], Error>) -> Void) where T: (Decodable & RequestIdentifier) {
        let searchString: String = withName.replacingOccurrences(of: " ", with: "%20")
    
        let urlString = Constants.domainUrl +
        item.requestComponent + EndpointComponent.search.value +
            "?sport_id=1&name=\(searchString)"

        request(urlString, method: .post, completion: completion)
    }
    
    func searchTeams(byPlayer: Player, completion: @escaping (Result<[Team], Error>) -> Void) {
        let urlString = Const.domainUrl +
        EndpointComponent.players.value + "/\(byPlayer.id)" + EndpointComponent.teams.value

        request(urlString, method: .get, completion: completion)
    }
    
    func searchMatches(byTeam: Team, completion: @escaping (Result<[Match], Error>) -> Void) {
        let urlString = Constants.domainUrl +
        EndpointComponent.teams.value + "/\(byTeam.id)" +
        EndpointComponent.events.value + "?page=1"

        request(urlString, method: .get, completion: completion)
    }

    func searchMatches(byPlayer: Player, completion: @escaping (Result<[Match], Error>) -> Void) {
        searchTeams(byPlayer: byPlayer, completion: {
            result in
            switch result {
            case .success(let teams):
                var matches = [Match]()
                var remainingTeams: Int = teams.count {
                    didSet {
                        if (remainingTeams == 0) {
                            completion(.success(matches))
                        }
                    }
                }

                for team in teams {
                    self.searchMatches(byTeam: team, completion: {
                        resultM in
                        switch resultM {
                        case .success(let ms):
                            matches.append(contentsOf: ms)
                        case .failure(let err2):
                            completion(.failure(err2))
                        }
                        remainingTeams -= 1
                    })
                }

            case .failure(let err):
                debugPrint(err)
            }
        })
    }

    func searchMatches<T>(by: [T], completion: @escaping (Result<[Match], Error>) -> Void) {
        var players = Set<Player>()
        var teams = Set<Team>()
        var matches = Set<Match>()
        
        for object in by {
            if let player = object as? Player {
                players.insert(player)
            }
            
            if let team = object as? Team {
                teams.insert(team)
            }
        }
        
        var remaining = teams.count + players.count {
            didSet {
                if (remaining == 0) {
                    debugPrint("returning: \(matches)")
                    return completion(.success(Array(matches)))
                }
            }
        }
        
        for player in players {
            searchMatches(byPlayer: player, completion: { result in
                switch (result) {
                    case .success(let ms):
                        ms.forEach {matches.insert($0) }
                    case .failure(let err):
                        debugPrint(err)
                }
                remaining -= 1
            })
        }
        
        for team in teams {
            searchMatches(byTeam: team, completion: { result in
                switch (result) {
                    case .success(let ms):
                        debugPrint(matches)
                        ms.forEach {matches.insert($0) }
                    case .failure(let err):
                        debugPrint(err)
                }
                remaining -= 1
            })
        }
    }
    
    func testNetwork() {
        search(item: Player.self, withName: "Kevin De Bru") { result in
            switch result {
                case .success(let players):
                    debugPrint(players)
                    self.searchTeams(byPlayer: players[0]) { result in
                        switch result {
                            case .success(let teams): do {
                                debugPrint(teams)
                                self.searchMatches(by: [teams[1], players[0]]) {
                                    rr in
                                    switch rr {
                                        case .success(let yep):
                                            debugPrint("MMM: \(yep)")
                                        case .failure(let err):
                                            debugPrint(err)
                                    }
                                }
                            }
                            case .failure(let err):
                                debugPrint(err)
                        }
                    }
                case .failure(let err):
                    debugPrint(err)
            }
        }
    }
    
    
    private func makeRequest<T: Decodable>(_ urlString: String, method: RequestType, type: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        let request = NSMutableURLRequest(
            url: URL(string: urlString)!,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 10.0
        )
        request.httpMethod = method.value
        request.allHTTPHeaderFields = Constants.headers
        
        URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {
            (jsonData, response, error) -> Void in
            
            if let error = error {
                return completion(.failure(error))
            }
            
            if jsonData == nil {
                return completion(.failure(NSError(
                    domain:"", code: 123, userInfo: nil
                )))
            }
            
            do {
                let object = try JSONDecoder().decode(SearchRequestResponse<T>.self, from: jsonData!)
                return completion(.success(object.data))
            } catch {
                debugPrint("DATA ERROR: " + (String(data: jsonData!, encoding: .utf8)!))
                return completion(.failure(error))
            }

        }).resume()
    }
}
