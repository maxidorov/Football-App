//
//  SubscriptionManager.swift
//  FootballApp
//
//  Created by Данила on 15.12.2021.
//

import Foundation
import Firebase

final class SubscriptionManager {
    static var currentSubscriptions: [SearchModel] = []
    
    static func updateSubscriptions() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        FirebaseSubscriptionService.getSubscriptions(user: userID) { (response) in
            currentSubscriptions = response.compactMap { item in
                if let player = item as? Player {
                    return SearchModel(type: .player, id: player.id, name: player.name, imageURL: player.photo)
                }
                
                if let team = item as? Team {
                    return SearchModel(type: .team, id: team.id, name: team.name, imageURL: team.logo)
                }
                return nil
            }
        }
    }
}
