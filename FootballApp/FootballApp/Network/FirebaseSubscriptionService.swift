//
//  FirebaseSubscriptionService.swift
//  FootballApp
//
//  Created by Андрей on 13.12.2021.
//

import Foundation
import Firebase

class FirebaseSubscriptionService {
    
    private static var dataBase = Firestore.firestore()
    
    private enum Subscription {
        case team
        case player
    }
    
    static func subscribe(user: String, team: String) {
        self.subscribe(user: user, type: .team, subscriptionName: team)
    }
    
    static func subscribe(user: String, player: String) {
        self.subscribe(user: user, type: .player, subscriptionName: player)
    }
    
    static func unsubscribe(user: String, team: String) {
        self.unsubscribe(user: user, type: .team, subscriptionName: team)
    }
    
    static func unsubscribe(user: String, player: String) {
        self.unsubscribe(user: user, type: .player, subscriptionName: player)
    }
    
    private static func subscribe(user: String,
                           type: Subscription,
                           subscriptionName: String) {
        let docData: [String: Any] = [
            "name" : subscriptionName
        ]
        
        let docRef = dataBase.collection("userSubscriptions")
                             .document(user)
                             .collection((type == .team ? "subscribedTeams" : "subscribedPlayers"))
                             .document(subscriptionName)
        
        docRef.setData(docData) {
            error in
            if let error = error {
                debugPrint("Error writing document: \(error)")
            } else {
                debugPrint("Document successfully written!")
            }
        }
    }
    
    private static func unsubscribe(user: String,
                            type: Subscription,
                            subscriptionName: String) {
        dataBase.collection("userSubscriptions")
                .document(user)
                .collection((type == .team ? "subscribedTeams" : "subscribedPlayers"))
                .document(subscriptionName)
                .delete()
    }
}
