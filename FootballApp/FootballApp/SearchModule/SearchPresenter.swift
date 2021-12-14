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
    var network: NetworkProtocol
    
    private var searchWorkItem: DispatchWorkItem?
    
    // MARK: - Public methods
    
    init(network: NetworkProtocol) {
        self.network = network
    }
    
    func didTypeSearch(string: String) {
        searchWorkItem?.cancel()
        
        if string == "" {
            models = []
            view?.presentModel()
            return
        }
        
        guard let selectedSegment = view?.selectedSegment else { return }
        let searchWorkItem = DispatchWorkItem { [weak self] in
            self?.view?.makeIndicator(active: true)
            switch selectedSegment {
            case .player:
                self?.performSearchPlayers(for: string)
            case .team:
                self?.performSearchTeams(for: string)
            default:
                break
            }
        }
        
        DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(450), execute: searchWorkItem)
        
        self.searchWorkItem = searchWorkItem
    }
    
    // MARK: - private methods
    
    private func performSearchPlayers(for name: String) {
        self.network.search(item: Player.self, withName: name, completion: { (result) in
            switch result {
            case .success(let players):
                self.models = players.map { player in
                    SearchModel(type: .player, id: player.id, name: player.name, imageURL: player.photo)
                }
                self.view?.makeIndicator(active: false)
                self.view?.presentModel()
            case .failure(let error):
                print(error)
            }
        })
    }
    
    private func performSearchTeams(for name: String) {
        self.network.search(item: Team.self, withName: name, completion: { (result) in
            switch result {
            case .success(let teams):
                self.models = teams.map({ (team) -> SearchModel in
                    return SearchModel(type: .team, id: team.id, name: team.name, imageURL: team.logo)
                })
                self.view?.makeIndicator(active: false)
                self.view?.presentModel()
            case .failure(let error):
                print(error)
            }
        })
    }
}
