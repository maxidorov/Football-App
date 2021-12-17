//
//  SubscriptionManager.swift
//  FootballApp
//
//  Created by Данила on 15.12.2021.
//

import Foundation
import Firebase

protocol SubscriptionManagerDelegate: AnyObject {
    func updateMatchesWith(oldModel: [SearchModel], newModel: [SearchModel])
}

final class SubscriptionManager {
    
    static var currentSubscriptions: [SearchModel] = [] {
        didSet {
            delegate?.updateMatchesWith(oldModel: oldValue, newModel: currentSubscriptions)
        }
    }
    
    static func updateSubscriptions(completion: @escaping ([SearchModel]) -> Void = {_ in}) {
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
            completion(currentSubscriptions)
        }
    }
    
    static var subscriptionCheckSet: Set<Int> {
        Set(currentSubscriptions.map { $0.id })
    }
    
    static weak var delegate: SubscriptionManagerDelegate?
}
