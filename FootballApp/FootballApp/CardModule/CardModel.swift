//
//  PlayerCardModel.swift
//  FootballApp
//
//  Created by Данила on 14.12.2021.
//

import UIKit

fileprivate enum TypesContent: Int {
    case image = 0
    case label = 1
    case subscribe = 2
}

enum CardCellSizes: Int {
    case imageHeight = 120
    case labelHeignt = 50
    case subscribeHeight = 80
    
    static func getCellSize(for row: Int) -> CGSize {
        let width = Int(UIScreen.main.bounds.width)
        switch row {
            case TypesContent.image.rawValue:
                return CGSize(width: width, height: CardCellSizes.imageHeight.rawValue)
            case TypesContent.label.rawValue:
                return CGSize(width: width, height: CardCellSizes.labelHeignt.rawValue)
            case TypesContent.subscribe.rawValue:
                return CGSize(width: width, height: CardCellSizes.subscribeHeight.rawValue)
            default:
                return .zero
        }
    }
}
