//
//  AddToCallendarCell.swift
//  FootballApp
//
//  Created by Gleb Zavyalov on 17.12.2021.
//

import UIKit
import EventKit
import EventKitUI

class AddToCallendarCell: UICollectionViewCell, EKEventEditViewDelegate {
    
    enum Constants {
        static let identifier = "AddToCallendarCell"
        static let cellHeight: CGFloat = 50
        static let cornerRounds: CGFloat = MiniMatchCell.Constants.cornerRadius
    }
    
    var presentAction: ((UIViewController) -> Void)?
    
    lazy var eventStore : EKEventStore = EKEventStore()
    
    let button: UIButton = {
        let but = UIButton()
        but.setTitle("Add to calendar", for: .normal)
        but.setTitleColor(.secondaryLabel, for: .normal)
        but.addTarget(self, action: #selector(openCalendar), for: .touchUpInside)
        return but
    } ()
    
    var match: Match?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = Constants.cornerRounds
        clipsToBounds = true
        
        addSubviews(button)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        button.frame = CGRect(
            origin: .zero,
            size: frame.size
        )
    }
    
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    @objc func openCalendar() {
        guard let match = match else { return }
        
        eventStore.requestAccess(to: .event) { (granted, error) in
            if (granted) && (error == nil) {
                let event:EKEvent = EKEvent(eventStore: self.eventStore)
                
                event.title = "\(match.name ?? "")"
                event.startDate = (match.startAt ?? "").toDateForm
                event.endDate = Calendar.current.date(byAdding: .minute, value: 105, to: event.startDate)
                
                onMainThreadAsync {
                    let eventController = EKEventEditViewController()
                    eventController.event = event
                    eventController.eventStore = self.eventStore
                    eventController.editViewDelegate = self
                    self.presentAction?(eventController)
                }
            }
        }
        
    }
    
}
