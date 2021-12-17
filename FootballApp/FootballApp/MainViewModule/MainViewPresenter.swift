//
//  MainViewPresenter.swift
//  FootballApp
//
//  Created by Gleb Zavyalov on 10.12.2021.
//

import Foundation
import FirebaseAuth

protocol MainViewPresenterProtocol: AnyObject {
    var nextMatchPosition: Int { get }
    func viewDidLoad()
    func showLogoutAlert()
}

class MainViewPresenter: MainViewPresenterProtocol {
    private struct LogoutAlertString {
        static let title = "Are you sure you want to logout?"
        static let logoutAction = "Logout"
        static let cancelAction = "Cancel"
    }

    weak var view: MainView?
    
    private var mathces: [Match] = [] {
        didSet {
            matchesChanged()
        }
    }
    private lazy var subscribedEntities = [Any]()
    private lazy var network: Network = Network()
    private let logoutAlertTitle = LogoutAlertString.title
    
    var nextMatchPosition: Int = 0
    
    // MARK: - Protocol methods
    
    func viewDidLoad() {
        retrieveMatches()
    }

    @objc func showLogoutAlert() {
        let alert = UIAlertController(
            title: logoutAlertTitle,
            message: nil,
            preferredStyle: .alert
        )

        let logoutAction: (UIAlertAction) -> Void = { _ in self.logout() }
        alert.addAction(UIAlertAction(title: LogoutAlertString.cancelAction, style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: LogoutAlertString.logoutAction, style: .default, handler: logoutAction))
        view?.present(alert: alert)
    }

    private func logout() {
        try? Auth.auth().signOut()
    }
    
    // MARK: - Private methods
    
    private func retrieveMatches() {
        SubscriptionManager.delegate = self
        
        SubscriptionManager.updateSubscriptions { (models) in
            self.updateMatchesWith(models: models)
        }
        
    }
    
    private func updateMatchesWith(models: [SearchModel]) {
        subscribedEntities = models.compactMap {
            switch $0.type {
            case .player:
                return Player(id: $0.id)
            case .team:
                return Team(id: $0.id)
            default:
                return nil
            }
        }
        self.network.searchMatches(by: self.subscribedEntities, completion: { result in
            switch result {
            case .success(let matches):
                self.mathces = self.filterMatches(matches)
            case .failure(let err):
                debugPrint(err)
            }
        })
    }
    
    private func filterMatches(_ ms: [Match]) -> [Match] {
        let matches = ms.sorted(by: { $0.startAt ?? "" > $1.startAt ?? "" })
        let calendar = Calendar.current
        globalDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        var minimalDeltaTime:Int = Int.max
        var prevMax = 0

        for i in 0..<matches.count {
            let match = matches[i]
            guard let dateString = match.startAt,
                let date = globalDateFormatter.date(from: dateString) else {
                continue
            }
            let components = calendar.dateComponents([.day], from: Date(), to: date)
            let deltaTime = components.day ?? Int.max
            if (deltaTime < minimalDeltaTime && deltaTime >= 0) {
                minimalDeltaTime = deltaTime
                prevMax = i
            }
        }
        nextMatchPosition = prevMax
        return matches
    }
    
    private func matchesChanged() {
        view?.onMatchesChanged(matches: mathces)
    }
}

extension MainViewPresenter: SubscriptionManagerDelegate {
    func updateMatchesWith(oldModel: [SearchModel], newModel: [SearchModel]) {
        if oldModel != newModel {
            updateMatchesWith(models: newModel)
        }
    }
}
