//
//  SearchContract.swift
//  FootballApp
//
//  Created by Данила on 10.12.2021.
//

import Foundation

protocol SearchPresenterProtocol: AnyObject {
    func didTypeSearch(string: String)
    var models: [SearchModel] { get }
}

protocol SearchViewProtocol: AnyObject {
    func presentModel()
    func makeIndicator(active: Bool)
    var selectedSegment: ModelType { get }
}
