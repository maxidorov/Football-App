//
//  ViewController.swift
//  FootballApp
//
//  Created by Maxim V. Sidorov on 12/8/21.
//

import UIKit

class ViewController: UIViewController {
    private enum Constants {
        // CV = collectionView
        static let CVMatchesSectionsNumber: Int = 1
        static let CVFakeCellId: String = FakeCollectionViewCell.identifier
        
        // UI Constants
        static let headerViewHeight: CGFloat = 120
        static let bottomBarHeight: CGFloat = 80
        static let fakeCellMargin: CGFloat = 10
        static let fakeCellHeight: CGFloat = FakeCollectionViewCell.cellHeight
    }
    
    private lazy var collectionViewMatches: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(
            width: view.frame.width - 2 * Constants.fakeCellMargin,
            height: Constants.fakeCellHeight
        )
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return view
    } ()
    private lazy var headerView: UIView = UIView()
    private lazy var bottomBar: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGreen
        return view
    }()
    
    private lazy var fakeItems: [String] = (1...10).map { i -> String in return "Cell #\(i)"}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewSubviews: [UIView] = [
            headerView, collectionViewMatches, bottomBar,
        ]
        for v in viewSubviews { view.addSubview(v) }

        collectionViewMatches.backgroundColor = .clear
        collectionViewMatches.delegate = self
        collectionViewMatches.dataSource = self
        collectionViewMatches.register(
            FakeCollectionViewCell.self,
            forCellWithReuseIdentifier: Constants.CVFakeCellId
        )
        collectionViewMatches.reloadData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        var uiPrevMaxY: CGFloat = 0
        
        headerView.frame = CGRect(
            x: 0, y: 0,
            width: view.bounds.width, height: Constants.headerViewHeight
        )
        uiPrevMaxY += Constants.headerViewHeight
        
        collectionViewMatches.frame = CGRect(
            x: 0, y: uiPrevMaxY,
            width: view.bounds.width,
            height: -uiPrevMaxY + view.bounds.height - Constants.bottomBarHeight
        )
        uiPrevMaxY += collectionViewMatches.frame.height
        
        bottomBar.frame = CGRect(
            x: 0, y: uiPrevMaxY,
            width: view.bounds.width, height: Constants.bottomBarHeight
        )
    }
}

//MARK: - CollectionView Delegate & DataSource
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fakeItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionViewMatches.dequeueReusableCell(
            withReuseIdentifier: Constants.CVFakeCellId, for: indexPath
        ) as! FakeCollectionViewCell
        cell.configure(text: fakeItems[indexPath.row])
        return cell
    }
}
