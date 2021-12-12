//
//  SearchPresenter.swift
//  FootballApp
//
//  Created by Данила on 09.12.2021.
//

import Foundation

class SearchPresenter: SearchPresenterProtocol {
    weak var view: SearchViewProtocol?
    var models: [SearchModel] = []
    

    private var mockModels = [
        SearchModel(title: "Роналдиньо", image: nil),
        SearchModel(title: "Роналдо", image: nil),
        SearchModel(title: "Роналдо Зубастик", image: nil),
        SearchModel(title: "Рон Уизли", image: nil),
        SearchModel(title: "Роман Абрамович", image: nil),
        SearchModel(title: "Рональд Куман", image: nil),
        SearchModel(title: "Маркус Рэшфорд", image: nil),
        SearchModel(title: "Рональд Макдонаьлд", image: nil),
        SearchModel(title: "Романцев", image: nil),
        SearchModel(title: "Ривалдо", image: nil),
    ]
    
    private var searchWorkItem: DispatchWorkItem?
    
    // MARK: - Public methods
    
    func didTypeSearch(string: String) {
        searchWorkItem?.cancel()
        
        if string == "" {
            models = []
            view?.presentModel()
            return
        }
        
        models = mockModels.filter({ (model) -> Bool in
            let searchText = string.lowercased()
            return model.title.lowercased().contains(searchText)
        })
        
        let searchWorkItem = DispatchWorkItem { [weak self] in
            self?.view?.presentModel()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(330), execute: searchWorkItem)
        
        self.searchWorkItem = searchWorkItem
    }
    
    func configureCell(cell: SearchItemCell) {
        
    }
}
