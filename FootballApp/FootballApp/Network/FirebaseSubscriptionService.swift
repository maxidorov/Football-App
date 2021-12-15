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
    
    static func subscribe(user: String, teamId: Int) {
        self.subscribe(user: user, type: .team, subscriptionId: teamId)
    }
    
    static func subscribe(user: String, playerId: Int) {
        self.subscribe(user: user, type: .player, subscriptionId: playerId)
    }
    
    static func unsubscribe(user: String, teamId: Int) {
        self.unsubscribe(user: user, type: .team, subscriptionId: teamId)
    }
    
    static func unsubscribe(user: String, playerId: Int) {
        self.unsubscribe(user: user, type: .player, subscriptionId: playerId)
    }
    
    static func getApiKei(completion: @escaping (String) -> Void) {
        let docRef = dataBase.collection("appData").document("apiKey")

        docRef.getDocument() { (document, error) in
          if let document = document {
            if let data = document.data(), let key = data["key"] as? String {
                completion(key)
            }
          } else {
            debugPrint("Document does not exist.")
          }
        }
    }
    
    static func getSubscriptions(user: String, completion: @escaping ([Any]) -> Void) {
        var subscriptions : [Any] = []
        
        let dbRef = dataBase.collection("userSubscriptions").document(user)
        let teamsRef = dbRef.collection("subscribedTeams")
        let playersRef = dbRef.collection("subscribedPlayers")
        
        var remaining = 2 {
            didSet {
                if (remaining == 0) {
                    debugPrint("returning: \(subscriptions)")
                    return completion(subscriptions)
                }
            }
        }
    
        for (index, ref) in [teamsRef, playersRef].enumerated() {
            ref.getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    querySnapshot?.documents.forEach { document in
                        guard let id = document.data()["id"], let idAsInt = id as? Int else {
                            return completion([])
                        }
                        
                        subscriptions.append(index == 0 ? Team(id: idAsInt) : Player(id: idAsInt))
                    }
                }
                remaining -= 1
            }
        }
    }
    
    private static func subscribe(user: String,
                                  type: Subscription,
                                  subscriptionId: Int) {
        let docData: [String: Any] = [
            "id" : subscriptionId
        ]
        
        let docRef = dataBase.collection("userSubscriptions")
                             .document(user)
                             .collection((type == .team ? "subscribedTeams" : "subscribedPlayers"))
                             .document(String(subscriptionId))
        
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
                                    subscriptionId: Int) {
        dataBase.collection("userSubscriptions")
                .document(user)
                .collection((type == .team ? "subscribedTeams" : "subscribedPlayers"))
                .document(String(subscriptionId))
                .delete()
    }
}
