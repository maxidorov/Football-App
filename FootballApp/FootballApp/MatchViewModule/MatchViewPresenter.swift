//
//  MatchViewPresenter.swift
//  FootballApp
//
//  Created by Gleb Zavyalov on 13.12.2021.
//

import Foundation
import UIImageColors

protocol MatchViewPresenterProtocol: AnyObject {
    var match: Match? { get }
    var statistics: [StatisticUnit] { get }
    var homeTeamColor: UIImageColors? { get }
    var awayTeamColor: UIImageColors? { get }
    func loadStatistic()
}

class MatchViewPresenter: MatchViewPresenterProtocol {
    weak var view: MatchView?
    
    var homeTeamColor: UIImageColors?
    var awayTeamColor: UIImageColors?
    
    private lazy var network = Network()
    
    var statistics = [StatisticUnit]() {
        didSet {
            view?.statisticLoaded()
        }
    }

    
    var match: Match? {
        didSet {
            if (match != nil) {
                loadMatchData()
                loadColors()
                loadStatistic()
            }
        }
    }
    
    
    func loadMatchData() {
        view?.matchLoaded()
    }
    
    func loadStatistic() {
        network.getStatics(by: match!.id, completion: { [self]
            result in
            onMainThreadAsync {
                switch result {
                case .success(let stats):
                    
                    self.statistics = Array(Set(stats))
                    self.statistics.sort(by: {(a, b) in return a.id < b.id})
                    self.view?.statisticLoaded()
                case .failure:
                    break
                }
            }
        })
    }
    
    private func loadColors() {
        ImageLoader.shared.loadImage(with: match?.homeTeam.logo, completion: {
            result in
            switch (result) {
            case .success(let img):
                self.homeTeamColor = img.getColors()
            case .failure:
                break
            }
        })
        
        ImageLoader.shared.loadImage(with: match?.awayTeam.logo, completion: {
            result in
            switch (result) {
            case .success(let img):
                self.awayTeamColor = img.getColors()
            case .failure:
                break
            }
        })
    }
}
