//
//  PlayerCardPresenter.swift
//  FootballApp
//
//  Created by Данила on 14.12.2021.
//

import UIKit
import Firebase

final class CardPresenter: CardPresenterProtocol {
    
    var model: SearchModel
    
    weak var view: CardViewProtocol?
    
    weak var cellUpdater: CellUpdaterProtocol?
    
    init(model: SearchModel) {
        self.model = model
        self.model.subscriptonStatus = SubscriptionManager.currentSubscriptions.contains(where: { (model) -> Bool in
            model.id == self.model.id
        })
    }
    
    func configure(cell: CardCellProtocol) {
        cell.configure(with: model)
        
        guard let cell = cell as? CardSubscribeCell else { return }
        cell.subscribeButton.addTarget(self, action: #selector(subscribeButtonPressed(sender:)), for: .touchUpInside)
        cellUpdater = cell
    }
    
    @objc private func subscribeButtonPressed(sender: UIButton) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        if model.subscriptonStatus != true {
            subscribeProcessing(model: model, userID: userID)
        } else {
            unsubscribeProcessing(model: model, userID: userID)
        }
    }
    
    func identifier(for indexPath: IndexPath) -> String? {
        switch indexPath.row {
        case 0:
            return CardImageCell.identifier
        case 1:
            return CardLabelCell.identifier
        case 2:
            return CardSubscribeCell.identifier
        default:
            return nil
        }
    }
    
    private func unsubscribeProcessing(model: SearchModel, userID: String) {
        switch model.type {
            case .player:
            	FirebaseSubscriptionService.unsubscribe(user: userID, playerId: 	model.id) { (isUnsubscribe) in
            	    self.cellUpdater?.updateCell(with: !isUnsubscribe)
            	    self.model.subscriptonStatus = !isUnsubscribe
            	    SubscriptionManager.updateSubscriptions()
            }
            case .team:
                FirebaseSubscriptionService.unsubscribe(user: userID, teamId: model.id) { (isUnsubscribe) in
                    self.cellUpdater?.updateCell(with: !isUnsubscribe)
                    self.model.subscriptonStatus = !isUnsubscribe
                    SubscriptionManager.updateSubscriptions()
            }
        default:
            break
        }
        
    }
    
    private func subscribeProcessing(model: SearchModel, userID: String) {
        switch model.type {
            case .player:
                FirebaseSubscriptionService.subscribe(user: userID, playerModel: model) { (isSubscribe) in
                    self.cellUpdater?.updateCell(with: isSubscribe)
                    self.model.subscriptonStatus = isSubscribe
                    SubscriptionManager.updateSubscriptions()
                }
            case .team:
                FirebaseSubscriptionService.subscribe(user: userID, teamModel: model) { (isSubscribe) in
                    self.cellUpdater?.updateCell(with: isSubscribe)
                    self.model.subscriptonStatus = isSubscribe
                    SubscriptionManager.updateSubscriptions()
                }
            default:
                break
        }
    }
}
