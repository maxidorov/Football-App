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
            let filterModels = SubscriptionManager.currentSubscriptions.filter {
                $0.type == models.first?.type
            }
            
            if models == filterModels {
                return
            }
            
            models = SubscriptionManager.currentSubscriptions
            view?.presentModel()
            guard let index = view?.selectedSegment.rawValue else { return }
            showCurrentSubscription(with: index)
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
    
    func showCurrentSubscription(with segment: Int) {
        models = SubscriptionManager.currentSubscriptions.filter { $0.type.rawValue == segment }
        view?.presentModel()
    }
    
    // MARK: - private methods
    
    private func performSearchPlayers(for name: String) {
        self.network.search(item: Player.self, withName: name, completion: { (result) in
            switch result {
            case .success(let players):
                let playersSet = Set(players)
                self.models = playersSet.map { player in
                    SearchModel(type: .player, id: player.id, name: player.name, imageURL: player.photo)
                }.sorted(by: { (mod1, mod2) -> Bool in
                    mod1.id < mod2.id
                })
                self.view?.makeIndicator(active: false)
                self.view?.presentModel()
            case .failure(let error):
                self.view?.makeIndicator(active: false)
                print(error.localizedDescription)
            }
        })
    }
    
    private func performSearchTeams(for name: String) {
        self.network.search(item: Team.self, withName: name, completion: { (result) in
            switch result {
            case .success(let teams):
                let teams = Set(teams)
                self.models = teams.map({ (team) -> SearchModel in
                    return SearchModel(type: .team, id: team.id, name: team.name, imageURL: team.logo)
                }).sorted(by: { (mod1, mod2) -> Bool in
                    mod1.id < mod2.id
                })
                self.view?.makeIndicator(active: false)
                self.view?.presentModel()
            case .failure(let error):
                self.view?.makeIndicator(active: false)
                print(error)
            }
        })
    }
}
