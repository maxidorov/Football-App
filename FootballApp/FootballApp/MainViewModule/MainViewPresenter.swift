//
//  MainViewPresenter.swift
//  FootballApp
//
//  Created by Gleb Zavyalov on 10.12.2021.
//

import Foundation

protocol MainViewPresenterProtocol: AnyObject {
    func viewDidLoad()
    
}

class MainViewPresenter: MainViewPresenterProtocol {
    weak var view: MainView?
    
    private var mathces: [Match] = [] {
        didSet {
            matchesChanged()
        }
    }
    private lazy var subscribedEntities = [Any]()
    private lazy var network: Network = Network()
    
    // MARK: - Protocol methods
    
    func viewDidLoad() {
        retrieveMatches()
    }
    
    // MARK: - Private methods
    
    private func retrieveMatches() {
        //HARDCODE
        subscribedEntities.append(Player(id: 289, name: "Leo Messi", shortName: nil, hasPhoto: false, photo: nil, age: nil, position: nil, positionName: nil))
        
        network.searchMatches(by: subscribedEntities, completion: { result in
            switch result {
            case .success(let ms):
                self.mathces = ms
            case .failure(let err):
                debugPrint(err)
            }
        })
    }
    
    private func matchesChanged() {
        view?.onMatchesChanged(matches: mathces)
    }
}
