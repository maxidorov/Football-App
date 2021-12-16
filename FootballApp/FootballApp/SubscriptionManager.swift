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
                if let model = item as? SearchModel {
                    return SearchModel(type: .player, id: model.id, name: model.name, imageURL: model.imageURL)
                }
                
                return nil
            }
        }
    }
    
    static var subscriptionCheckSet: Set<Int> {
        Set(currentSubscriptions.map { $0.id })
    }
}
