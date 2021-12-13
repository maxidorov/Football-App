//
//  SearchPresenter.swift
//  FootballApp
//
//  Created by Данила on 09.12.2021.
//

import Foundation

class SearchPresenter: SearchPresenterProtocol {
    weak var view: SearchViewProtocol?
    var models: [SearchModel] = []
    var network: NetworkProtocol?
    
    private var searchWorkItem: DispatchWorkItem?
    
    // MARK: - Public methods
    
    func didTypeSearch(string: String) {
        searchWorkItem?.cancel()
        
        if string == "" {
            models = []
            view?.presentModel()
            return
        }
        
        guard let selectedSegment = view?.selectedSegment else { return }
        let searchWorkItem = DispatchWorkItem { [weak self] in
            if selectedSegment == 0 {
                self?.performSearchPlayers(for: string)
            } else {
                self?.performSearchTeams(for: string)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(330), execute: searchWorkItem)
        
        self.searchWorkItem = searchWorkItem
    }
    
    // MARK: - private methods
    
    private func performSearchPlayers(for name: String) {
        self.network?.search(item: Player.self, withName: name, completion: { (result) in
            switch result {
                case .success(let players):
                    self.models = players.map({ (player) -> SearchModel in
                        return SearchModel(type: .player, id: player.id, name: player.name)
                    })
                    self.view?.presentModel()
                case .failure(let error):
                    print(error)
            }
        })
    }
    
    private func performSearchTeams(for name: String) {
        self.network?.search(item: Team.self, withName: name, completion: { (result) in
            switch result {
                case .success(let teams):
                    self.models = teams.map({ (team) -> SearchModel in
                        return SearchModel(type: .team, id: team.id, name: team.name)
                    })
                    self.view?.presentModel()
                case .failure(let error):
                    print(error)
            }
        })
    }
}
