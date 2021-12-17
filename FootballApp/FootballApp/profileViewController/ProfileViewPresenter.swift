//
//  ProfileViewPresenter.swift
//  FootballApp
//
//  Created by Anna Lazareva on 17.12.2021.
//

import Foundation
import UIImageColors

protocol ProfileViewPresenterProtocol: AnyObject {
    var match: Match? { get }
    var statistics: [StatisticUnit] { get }
    var homeTeamColor: UIImageColors? { get }
    var awayTeamColor: UIImageColors? { get }
    func loadStatistic()

}

class ProfileViewPresenter: ProfileViewPresenterProtocol {
    var match: Match?

    var statistics: [StatisticUnit] = []

    var homeTeamColor: UIImageColors?

    var awayTeamColor: UIImageColors?

    func loadStatistic() {
        
    }
    
    weak var view: MatchView?
    
    //    var homeTeamColor: UIImageColors?
    //    var awayTeamColor: UIImageColors?
    
}
