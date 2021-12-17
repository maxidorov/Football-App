//
//  PubsCell.swift
//  FootballApp
//
//  Created by Gleb Zavyalov on 17.12.2021.
//

import UIKit
import MapKit

class PubsCell: UICollectionViewCell {
    
    enum Constants {
        static let identifier = "PubsCell"

        static let marginTop: CGFloat = 14
        static let cornerRounds: CGFloat = MiniMatchCell.Constants.cornerRadius
        
        static let openBSize: CGFloat = 44
    }
    
    private var pubView = PubMapView()
    
    private lazy var visualEffectView: UIView = {
        let blurEffect = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: blurEffect)
        return view
    } ()
    
    private lazy var button: UIButton = {
        let but = UIButton()
        but.setImage(UIImage(systemName: "map")?
                        .withTintColor(.label, renderingMode: .alwaysOriginal), for: .normal)
        but.addTarget(self, action: #selector(openMaps), for: .touchUpInside)

        return but
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .clear
    
        addSubviews(
            pubView,
            visualEffectView,
            button
        )
        
        pubView.layer.cornerRadius = Constants.cornerRounds
        pubView.clipsToBounds = true
        
        visualEffectView.layer.cornerRadius = Constants.openBSize / 2
        visualEffectView.clipsToBounds = true
    }
    
    
    override func layoutSubviews() {
        pubView.frame = CGRect(
            origin: CGPoint(
                x: 0, y: Constants.marginTop
            ),
            size: frame.size
        )
        
        visualEffectView.frame.size = CGSize(
            width: Constants.openBSize,
            height: Constants.openBSize
        )
        
        visualEffectView.frame.origin = CGPoint(
            x: pubView.frame.maxX - 12 - Constants.openBSize,
            y: pubView.frame.minY + 12
        )
        
        button.frame = visualEffectView.frame

            
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func openMaps() {
        if !pubView.pubsAround.isEmpty {
            MKMapItem.openMaps(with: pubView.pubsAround, launchOptions: nil)
        }
    }
    
}
