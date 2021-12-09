//
//  SearchViewController.swift
//  FootballApp
//
//  Created by Gleb Zavyalov on 08.12.2021.
//

import UIKit

class SearchViewController: UIViewController {
    private enum Constants {
        // CV = collectionView
        static let CVMatchesSectionsNumber: Int = 1
        static let CVFakeCellId: String = FakeCollectionViewCell.identifier
        
        // UI Constants
        static let searchBarHeight: CGFloat = 40
        static let bottomBarHeight: CGFloat = 80
        static let fakeCellMargin: CGFloat = 10
        static let fakeCellHeight: CGFloat = FakeCollectionViewCell.cellHeight
        static let statusBarHeight: CGFloat = {
            var statusBarHeight: CGFloat = 0
            if #available(iOS 13.0, *) {
                let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
                statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
            } else {
                statusBarHeight = UIApplication.shared.statusBarFrame.height
            }
            return statusBarHeight
        }()
    }
    
    private lazy var searchResultsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(
            width: view.frame.width - 2 * Constants.fakeCellMargin,
            height: Constants.fakeCellHeight
        )
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return view
    }()
    
    private var searchBar: UIView = {
        let searchbar = UISearchBar()
        searchbar.backgroundImage = UIImage()
        return searchbar
    }()
    private var bottomBar: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGreen
        view.isHidden = true
        return view
    }()
    
    private lazy var fakeItems: [String] = (1...100).map { i -> String in return "Search result #\(i)"}

    override func viewDidLoad() {
        super.viewDidLoad()

        [
            searchBar, searchResultsCollectionView, bottomBar,
        ].forEach { view.addSubview($0) }

        searchResultsCollectionView.backgroundColor = .clear
        searchResultsCollectionView.delegate = self
        searchResultsCollectionView.dataSource = self
        searchResultsCollectionView.register(
            FakeCollectionViewCell.self,
            forCellWithReuseIdentifier: Constants.CVFakeCellId
        )
        searchResultsCollectionView.reloadData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        var uiPrevMaxY: CGFloat = 0
        
        searchBar.frame = CGRect(
            x: 0, y: Constants.statusBarHeight,
            width: view.bounds.width, height: Constants.searchBarHeight
        )
        uiPrevMaxY += searchBar.frame.maxY + 12
        
        searchResultsCollectionView.frame = CGRect(
            x: 0, y: uiPrevMaxY,
            width: view.bounds.width,
            height: -uiPrevMaxY + view.bounds.height - Constants.bottomBarHeight
        )
        uiPrevMaxY += searchResultsCollectionView.frame.height
        
        bottomBar.frame = CGRect(
            x: 0, y: uiPrevMaxY,
            width: view.bounds.width, height: Constants.bottomBarHeight
        )
    }

}

//MARK: - CollectionView's Delegate & DataSource

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fakeItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = searchResultsCollectionView.dequeueReusableCell(
            withReuseIdentifier: Constants.CVFakeCellId, for: indexPath
        ) as! FakeCollectionViewCell
        cell.configure(text: fakeItems[indexPath.row])
        return cell
    }
}
