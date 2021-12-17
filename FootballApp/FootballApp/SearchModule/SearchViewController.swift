//
//  SearchViewController.swift
//  FootballApp
//
//  Created by Gleb Zavyalov on 08.12.2021.
//

import UIKit
import SwiftUI

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
        collectionView.backgroundColor = .systemBackground
        collectionView.clipsToBounds = true
        collectionView.register(SearchItemCell.self, forCellWithReuseIdentifier: SearchItemCell.identifier)
        collectionView.keyboardDismissMode = .interactive
        return collectionView
    }()
    
    private lazy var searchController = UISearchController(searchResultsController: nil)
    
    private lazy var kostilView: UIView = {
        let howToCode = UIView()
        view.backgroundColor = .systemBackground
        howToCode.frame = .zero
        return howToCode
    }()
    
    private lazy var searchTypeSegmentControl: UISegmentedControl = {
        let searchTypeSegmentControll = UISegmentedControl()
        searchTypeSegmentControll.insertSegment(withTitle: "Players", at: 0, animated: false)
        searchTypeSegmentControll.insertSegment(withTitle: "Teams", at: 1, animated: false)
        searchTypeSegmentControll.selectedSegmentIndex = 0
        searchTypeSegmentControll.translatesAutoresizingMaskIntoConstraints = false
        searchTypeSegmentControll.addTarget(self, action: #selector(updateSearchBySegment), for: .valueChanged)
        searchTypeSegmentControll.backgroundColor = .systemBackground
        return searchTypeSegmentControll
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .secondaryLabel
        return indicator
    }()
    
    private var animateSegment: Bool = false
    
    // MARK: - Override methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = Constants.tabBarTitle
        
        navigationItem.largeTitleDisplayMode = .automatic
        navigationController?.navigationBar.prefersLargeTitles = true

        view.addSubviews(collectionView, kostilView, searchTypeSegmentControl, activityIndicator)

        setupSearchController()
        makeIndicator(active: false)
        kostilView.backgroundColor = .systemBackground

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.showCurrentSubscription(with: searchTypeSegmentControl.selectedSegmentIndex + 1)
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupSegmentControl(animated: animateSegment)
        animateSegment = true

        
        activityIndicator.center = CGPoint(x: view.center.x, y: view.safeAreaLayoutGuide.layoutFrame.minY + 100)
    }
    
    // MARK: - Private methods

    private func showActivityIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        collectionView.fadeOut()
    }
    
    private func hideActivityIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
        collectionView.fadeIn()
    }
    
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
                                                        y: self.view.safeAreaLayoutGuide.layoutFrame.minY + 7,
                                                        width: self.view.frame.width * 0.9,
                                                        height: 31)
            let collectionViewHeight = self.view.frame.height - self.searchTypeSegmentControl.frame.maxY
            self.collectionView.frame = CGRect(x: 0,
                                            y: self.view.safeAreaLayoutGuide.layoutFrame.minY,
                                            width: self.view.frame.width,
                                            height: collectionViewHeight)
            self.kostilView.frame = CGRect(
                x: 0, y: self.view.safeAreaLayoutGuide.layoutFrame.minY,
                width: self.view.frame.width,
                height: 50
            )

        }
    }
    
    @objc private func updateSearchBySegment() {
        if let text = searchController.searchBar.text, text != "" {
            presenter?.didTypeSearch(string: text)
        } else {
            presenter?.showCurrentSubscription(with: searchTypeSegmentControl.selectedSegmentIndex + 1)
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
    
    func makeIndicator(active: Bool) {
        onMainThreadAsync {
            switch active {
            case true:
                self.showActivityIndicator()
            case false:
                self.hideActivityIndicator()
            }
        }
    }
    
    var selectedSegment: ModelType {
        switch searchTypeSegmentControl.selectedSegmentIndex {
        case 0:
            return .player
        case 1:
            return .team
        default:
            return .unknown
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard var newModel = presenter?.models[indexPath.row] else { return }
        newModel.subscriptonStatus = SubscriptionManager.subscriptionCheckSet.contains(newModel.id)
        let cardviewcontroller = CardAssembly.createCardModule(with: newModel)
        
        present(cardviewcontroller, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(
            width: collectionView.bounds.width - 32,
            height: SearchItemCell.Constants.Appearance.cellHeight
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
     }
}

// MARK: - UISearchResultsUpdating

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        presenter?.didTypeSearch(string: text)
    }
}
