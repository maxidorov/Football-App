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
            case .success(let matches):
                self.mathces = self.filterMatches(matches)
            case .failure(let err):
                debugPrint(err)
            }
        })
    }
    
    private func filterMatches(_ ms: [Match]) -> [Match] {
        var array = ms.sorted(by: { $0.startAt ?? "" > $1.startAt ?? "" })
        let calendar = Calendar.current
        globalDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        array = array.filter { match in
            guard
                let dateString = match.startAt,
                let date = globalDateFormatter.date(from: dateString) else {
                return false
            }
         
            // date - now <= 7
            let components = calendar.dateComponents([.day], from: Date(), to: date)
            return  components.day.map { $0 <= 7 } ?? false
        }
        return array
    }
    
    private func matchesChanged() {
        view?.onMatchesChanged(matches: mathces)
    }
}
