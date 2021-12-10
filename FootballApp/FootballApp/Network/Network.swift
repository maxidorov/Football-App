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
        case get = "GET"
        case post = "POST"
    }
    
    func search<T>(item: T.Type,  withName: String, completionHandler: @escaping (Result<[T], Error>) -> Void) where T: (Decodable & RequestIdentifier) {
        let searchString: String = withName.replacingOccurrences(of: " ", with: "%20")
    
        let urlString = Constants.domainUrl +
        item.requestComponent + EndpointComponent.search.value +
            "?sport_id=1&name=\(searchString)"
        
        createRequest(urlString, method: .post, type: [T].self, completion: { result in
            switch result {
                case .success(let obj):
                    completionHandler(.success(obj))
                case .failure(let err):
                    return completionHandler(.failure(err))
            }
        })
    }
    
    func searchTeams(byPlayer: Player, completionHandler: @escaping (Result<[Team], Error>) -> Void) {
        let urlString = Const.domainUrl +
        EndpointComponent.players.value + "/\(byPlayer.id)" + EndpointComponent.teams.value
        
        createRequest(urlString, method: .get, type: [Team].self, completion: { result in
            switch result {
            case .success(let teams):
                completionHandler(.success(teams))
            case .failure(let err):
                return completionHandler(.failure(err))
            }
        })
    }
    
    func searchMatches(byTeam: Team, completionHandler: @escaping (Result<[Match], Error>) -> Void) {
        let urlString = Constants.domainUrl +
        EndpointComponent.teams.value + "/\(byTeam.id)" +
        EndpointComponent.events.value + "?page=1"
        
        createRequest(urlString, method: .get, type: [Match].self, completion: { result in
            switch result {
                case .success(let matches):
                    completionHandler(.success(matches))
                case .failure(let err):
                    return completionHandler(.failure(err))
            }
        })
    }
    

    
    func searchMatches(byPlayer: Player, completionHandler: @escaping (Result<[Match], Error>) -> Void) {
        searchTeams(byPlayer: byPlayer, completionHandler: {
            result in
            switch result {
                case .success(let teams):
                    do {
                        var matches = [Match]()
                        var remainingTeams: Int = teams.count {
                            didSet {
                                if (remainingTeams == 0) {
                                    completionHandler(.success(matches))
                                }
                            }
                        }
                        
                        for team in teams {
                            self.searchMatches(byTeam: team, completionHandler: {
                                resultM in
                                switch resultM {
                                    case .success(let ms):
                                        matches.append(contentsOf: ms)
                                    case .failure(let err2):
                                        completionHandler(.failure(err2))
                                }
                                remainingTeams -= 1
                            })
                        }
                    }
                case .failure(let err):
                    debugPrint(err)
            }
        })
    }
    
    func searchMatches<T>(by: [T], completionHandler: @escaping (Result<[Match], Error>) -> Void) {
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
                    return completionHandler(.success(Array(matches)))
                }
            }
        }
        
        for player in players {
            searchMatches(byPlayer: player, completionHandler: { result in
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
            searchMatches(byTeam: team, completionHandler: { result in
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
                    self.searchTeams(byPlayer: players[0], completionHandler: { result in
                        switch result {
                            case .success(let teams): do {
                                debugPrint(teams)
                                self.searchMatches(by: [teams[1], players[0]], completionHandler: {
                                    rr in
                                    switch rr {
                                        case .success(let yep):
                                            debugPrint("MMM: \(yep)")
                                        case .failure(let err):
                                            debugPrint(err)
                                    }

                                })
                                
                            }
                            case .failure(let err):
                                debugPrint(err)
                        }
                    })
                case .failure(let err):
                    debugPrint(err)
            }
        }
    }
    
    
    private func createRequest<T: Decodable>(_ urlString: String, method: RequestType, type: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        let request = NSMutableURLRequest(
            url: URL(string: urlString)!,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 10.0
        )
        request.httpMethod = method.rawValue
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
