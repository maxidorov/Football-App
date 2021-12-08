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
        static let headerViewHeight: CGFloat = SearchHeaderView.headerHeight
        static let bottomBarHeight: CGFloat = 80
        static let fakeCellMargin: CGFloat = 10
        static let fakeCellHeight: CGFloat = FakeCollectionViewCell.cellHeight
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
    
    private lazy var headerView: UIView = SearchHeaderView()
    private lazy var bottomBar: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGreen
        view.isHidden = true
        return view
    }()
    
    private lazy var fakeItems: [String] = (1...100).map { i -> String in return "Search result #\(i)"}

    override func viewDidLoad() {
        super.viewDidLoad()

        let viewSubviews: [UIView] = [
            headerView, searchResultsCollectionView, bottomBar,
        ]
        for v in viewSubviews { view.addSubview(v) }

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
        
        headerView.frame = CGRect(
            x: 0, y: 0,
            width: view.bounds.width, height: Constants.headerViewHeight
        )
        uiPrevMaxY += Constants.headerViewHeight + 20
        
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
