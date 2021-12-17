//
//  PlayerCardContract.swift
//  FootballApp
//
//  Created by Данила on 14.12.2021.
//

import UIKit

protocol CardCellProtocol {
    func configure(with model: SearchModel, playerInfo: PlayerInfo?, indexPath: IndexPath?)
}

protocol CardViewProtocol: AnyObject {
    func updateViewWithInfo()
}

protocol CardPresenterProtocol: AnyObject {
    var cellsCount: Int { get }
    func identifier(for indexPath: IndexPath) -> String?
    func configure(cell: CardCellProtocol, indexPath: IndexPath)
    func getExtraInfo()
}


protocol CellUpdaterProtocol: AnyObject {
    func updateCell(with subscribe: Bool)
}
