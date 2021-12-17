//
//  NetworkTests.swift
//  FootballAppTests
//
//  Created by Gleb Zavyalov on 17.12.2021.
//

import XCTest
@testable import FootballApp

class NetworkTests: XCTestCase {
    private let network = NetworkTest()
    
    private let teams = []
    
    func testNetwork1() {
        network.search(item: Player.self, withName: "Messi", completion: {
            result in
            
        })
        
        XCTAssertEqual(network.searchCalls, 3)
    }
}


class NetworkTest: Network {
    
    var searchCalls = 0
    
    override func search<T>(item: T.Type,  withName: String, completion: @escaping (Result<[T], Error>) -> Void) where T: (Decodable & RequestIdentifier) {
        super.search(item: item, withName: withName, completion: completion)
        searchCalls += 1
    }
    
    override func searchMatches(byTeam: Team, completion: @escaping (Result<[Match], Error>) -> Void) {
        
    }
    
    override func searchMatches(byPlayer: Player, completion: @escaping (Result<[Match], Error>) -> Void) {
        
    }
    
    override func searchTeams(byPlayer: Player, completion: @escaping (Result<[Team], Error>) -> Void) {
        
    }
    
    override func searchMatches<T>(by: [T], completion: @escaping (Result<[Match], Error>) -> Void) {
        
    }
}
