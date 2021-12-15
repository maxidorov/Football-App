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
        collectionView.backgroundColor = .white
        collectionView.register(CardLabelCell.self, forCellWithReuseIdentifier: CardLabelCell.identifier)
        collectionView.register(CardImageCell.self, forCellWithReuseIdentifier: CardImageCell.identifier)
        collectionView.register(CardSubscribeCell.self, forCellWithReuseIdentifier: CardSubscribeCell.identifier)
        return collectionView
    }()
    
    // MARK: - override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
}

// MARK: - UICollectionViewDelegate & DataSource

extension CardViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let identifier = presenter?.identifier(for: indexPath),
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? (CardCellProtocol & UICollectionViewCell) else { return UICollectionViewCell() }
        presenter?.configure(cell: cell)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CardViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CardModel.getCellSize(for: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: 20)
    }
}

// MARK: - PlayerCardViewProtocol

extension CardViewController: CardViewProtocol {}
