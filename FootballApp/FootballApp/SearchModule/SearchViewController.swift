//
//  SearchViewController.swift
//  FootballApp
//
//  Created by Gleb Zavyalov on 08.12.2021.
//

import UIKit

class SearchViewController: UIViewController {
    enum Constants {
        static let tabBarTitle: String = "Search"
    }
    
    var presenter: SearchPresenterProtocol?
    
    // MARK: - private properties
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.register(SearchItemCell.self, forCellWithReuseIdentifier: SearchItemCell.identifier)
        return collectionView
    }()
    
    private lazy var searchController = UISearchController(searchResultsController: nil)
    
    private lazy var searchTypeSegmentControl: UISegmentedControl = {
        let searchTypeSegmentControll = UISegmentedControl(frame: .zero)
        searchTypeSegmentControll.insertSegment(withTitle: "Игроки", at: 0, animated: false)
        searchTypeSegmentControll.insertSegment(withTitle: "Команды", at: 1, animated: false)
        searchTypeSegmentControll.selectedSegmentIndex = 0
        searchTypeSegmentControll.translatesAutoresizingMaskIntoConstraints = false
        return searchTypeSegmentControll
    }()
    
    private var animateSegment: Bool = false
    
    // MARK: - Override methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = Constants.tabBarTitle
        
        navigationItem.largeTitleDisplayMode = .automatic
        navigationController?.navigationBar.prefersLargeTitles = true
        view.addSubviews(collectionView, searchTypeSegmentControl)
        
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.751727879, green: 0.7929214835, blue: 0.845862329, alpha: 1)]
        
        setupSearchController()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupSegmentControl(animated: animateSegment)
        animateSegment = true
        
        let collectionViewHeight = view.frame.height - searchTypeSegmentControl.frame.maxY
        collectionView.frame = CGRect(x: 0,
                                      y: view.safeAreaLayoutGuide.layoutFrame.minY,
                                      width: view.frame.width,
                                      height: collectionViewHeight)
        
    }

    // MARK: - Private methods
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.hidesNavigationBarDuringPresentation = true
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func setupSegmentControl(animated: Bool) {
        UIView.animate(withDuration: animated ? 0.3 : 0) {
            self.searchTypeSegmentControl.frame = CGRect(x: self.view.frame.width * 0.05,
                                                         y: self.view.safeAreaLayoutGuide.layoutFrame.minY + 6,
                                                         width: self.view.frame.width * 0.9,
                                                         height: 31)
        }
    }
}

// MARK: - SearchViewProtocol

extension SearchViewController: SearchViewProtocol {
    func presentModel() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    var selectedSegment: ModelType {
        switch searchTypeSegmentControl.selectedSegmentIndex {
        case 0:
            return .player
        case 1:
            return .team
        default:
            return .unkown
        }
    }
}

//MARK: - CollectionView's Delegate & DataSource

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter?.models.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchItemCell.identifier, for: indexPath) as? SearchItemCell else { return UICollectionViewCell() }
        
        if let model = presenter?.models[indexPath.row] {
            cell.configureWithModel(model: model)
        }
        
        return cell
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.bounds.width - 30, height: 46)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: 20)
    }
}

// MARK: - UISearchResultsUpdating

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        presenter?.didTypeSearch(string: text)
    }
}
