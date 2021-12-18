//
//  PlayerCardViewController.swift
//  FootballApp
//
//  Created by Данила on 14.12.2021.
//

import UIKit

final class CardViewController: UIViewController {
    
    // MARK: - public properties
    
    var presenter: CardPresenterProtocol?
    
    // MARK: - private properties
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .secondarySystemBackground
        collectionView.register(CardLabelCell.self, forCellWithReuseIdentifier: CardLabelCell.identifier)
        collectionView.register(CardImageCell.self, forCellWithReuseIdentifier: CardImageCell.identifier)
        collectionView.register(CardSubscribeCell.self, forCellWithReuseIdentifier: CardSubscribeCell.identifier)
        collectionView.register(CardParameterCell.self, forCellWithReuseIdentifier: CardParameterCell.identifier)
        return collectionView
    }()
    
    // MARK: - override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        presenter?.getExtraInfo()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
}

// MARK: - UICollectionViewDelegate & DataSource

extension CardViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter?.cellsCount ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let identifier = presenter?.identifier(for: indexPath),
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? (CardCellProtocol & UICollectionViewCell) else { return UICollectionViewCell() }
        presenter?.configure(cell: cell, indexPath: indexPath)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CardViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CardCellSizes.getCellSize(for: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: 20)
    }
}

// MARK: - PlayerCardViewProtocol

extension CardViewController: CardViewProtocol {
    func updateViewWithInfo() {
        onMainThreadAsync {
            self.collectionView.reloadData()
        }
    }
}
