//
//  PlayerCardPresenter.swift
//  FootballApp
//
//  Created by Данила on 14.12.2021.
//

import UIKit
import Firebase

final class CardPresenter: CardPresenterProtocol {
    
    var model: CardModel
    
    weak var view: CardViewProtocol?
    
    weak var cellUpdater: CellUpdaterProtocol?
    
    init(model: CardModel) {
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
            FirebaseSubscriptionService.subscribe(user: userID, playerId: model.id) { (isSubscribe) in
                self.cellUpdater?.updateCell(with: isSubscribe)
                self.model.subscriptonStatus = isSubscribe
                SubscriptionManager.updateSubscriptions()
            }
        } else {
            FirebaseSubscriptionService.unsubscribe(user: userID, playerId: model.id) { (isUnsubscribe) in
                self.cellUpdater?.updateCell(with: !isUnsubscribe)
                self.model.subscriptonStatus = !isUnsubscribe
                SubscriptionManager.updateSubscriptions()
            }
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
}
