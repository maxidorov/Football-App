//
//  PlayerCardContract.swift
//  FootballApp
//
//  Created by Данила on 14.12.2021.
//

import UIKit

protocol CardCellProtocol {
    func configure(with model: CardModel)
}

protocol CardViewProtocol: AnyObject {}

protocol CardPresenterProtocol: AnyObject {
    func identifier(for indexPath: IndexPath) -> String?
    func configure(cell: CardCellProtocol)
}


protocol CellUpdaterProtocol: AnyObject {
    func updateCell(with subscribe: Bool)
}
