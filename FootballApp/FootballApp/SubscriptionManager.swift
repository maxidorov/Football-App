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
    
    static func updateSubscriptions(completion: ([SearchModel]) -> Void = {_ in}) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        FirebaseSubscriptionService.getSubscriptions(user: userID) { (response) in
            currentSubscriptions = response.compactMap { item in
                if let model = item as? SearchModel {
                    return SearchModel(type: model.type, id: model.id, name: model.name,
                                       imageURL: model.imageURL, subscriptonStatus: model.subscriptonStatus,
                                       description: model.description)
                }
                
                return nil
            }
        }
    }
    
    static var subscriptionCheckSet: Set<Int> {
        Set(currentSubscriptions.map { $0.id })
    }
}
