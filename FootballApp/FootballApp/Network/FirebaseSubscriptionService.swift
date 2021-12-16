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
    
    static func subscribe(user: String, teamModel: SearchModel, completion: @escaping (Bool) -> Void) {
        self.subscribe(user: user, type: .team, subscriptionModel: teamModel, completion: completion)
    }
    
    static func subscribe(user: String, playerModel: SearchModel, completion: @escaping (Bool) -> Void) {
        self.subscribe(user: user, type: .player, subscriptionModel: playerModel, completion: completion)
    }
    
    static func unsubscribe(user: String, teamId: Int, completion: @escaping (Bool) -> Void) {
        self.unsubscribe(user: user, type: .team, subscriptionId: teamId, completion: completion)
    }
    
    static func unsubscribe(user: String, playerId: Int, completion: @escaping (Bool) -> Void) {
        self.unsubscribe(user: user, type: .player, subscriptionId: playerId, completion: completion)
    }
    
    static func getApiKei(completion: @escaping (String?) -> Void) {
        let docRef = dataBase.collection("appData").document("apiKey")

        docRef.getDocument() { (document, error) in
          if let document = document,
             let data = document.data(), let key = data["key"] as? String {
                completion(key)
          } else {
            debugPrint("Document does not exist.")
            completion(nil)
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
    
        for ref in [teamsRef, playersRef] {
            ref.getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    querySnapshot?.documents.forEach { document in
                        let model = SearchModel(dict: document.data())
                        
                        guard let modelUnwrapped = model else {
                            return completion([])
                        }
                        
                        subscriptions.append(modelUnwrapped)
                    }
                }
                remaining -= 1
            }
        }
    }
    
    private static func subscribe(user: String,
                                  type: Subscription,
                                  subscriptionModel: SearchModel, completion: @escaping (Bool) -> Void) {
        let docData: [String: Any] = [
            "id" : subscriptionModel.id,
            "name" : subscriptionModel.name,
            "imageUrl" : subscriptionModel.imageURL ?? "",
            "type" : (subscriptionModel.type == .team ? 2 : 1),
            "subscriptionStatus" : true
        ]
        
        let docRef = dataBase.collection("userSubscriptions")
                             .document(user)
                             .collection((type == .team ? "subscribedTeams" : "subscribedPlayers"))
                             .document(String(subscriptionModel.id))
        
        docRef.setData(docData) {
            error in
            if let error = error {
                debugPrint("Error writing document: \(error)")
                completion(false)
            } else {
                debugPrint("Document successfully written!")
                completion(true)
            }
        }
    }
    
    private static func unsubscribe(user: String,
                                    type: Subscription,
                                    subscriptionId: Int,
                                    completion: @escaping (Bool) -> Void) {
        dataBase.collection("userSubscriptions")
                .document(user)
                .collection((type == .team ? "subscribedTeams" : "subscribedPlayers"))
                .document(String(subscriptionId))
            .delete { (error) in
                if error == nil {
                    completion(true)
                } else {
                    completion(false)
                }
            }
    }
}
