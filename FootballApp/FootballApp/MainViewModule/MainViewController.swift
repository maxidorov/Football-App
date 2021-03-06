//
//  MainViewController.swift
//  FootballApp
//
//  Created by Gleb Zavyalov on 08.12.2021.
//

import UIKit

class MainViewController: UIViewController {
    enum Constants {
        // CV = collectionView
        static let CVMatchesSectionsNumber: Int = 1
        static let matchCellId: String = MatchCell.Constants.identifier
        static let matchCellMargin: CGFloat = 16
        static let matchCellHeight: CGFloat = MatchCell.Constants.cellHeight
        
        // UI Constants
        static let headerViewHeight: CGFloat = 140
        static let bottomBarHeight: CGFloat = 80
        static let logoutButtonSide: CGFloat = 34
        
        // Other
        static let tabBarTitle = "Matches"
    }
    
    private let layout = UICollectionViewFlowLayout()
    private lazy var matchesCollectionView: UICollectionView = {
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return view
    } ()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .secondaryLabel
        indicator.startAnimating()
        return indicator
    }()
    
    var mainViewPresenter: MainViewPresenter?

    private var headerView: UIView = UIView()

    private var headerLabel: UILabel = {
        let label = UILabel()
        let font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.font = font
        label.text = Constants.tabBarTitle
        return label
    }()

    private lazy var logoutButton: UIButton = {
        let button = UIButton()

        let largeConfig = UIImage.SymbolConfiguration(
            pointSize: Constants.logoutButtonSide,
            weight: .medium,
            scale: .medium
        )

        let image = UIImage(
            systemName: "person.crop.circle",
            withConfiguration: largeConfig
        )

        button.setImage(image, for: .normal)
        button.contentMode = .scaleAspectFill

        button.addTarget(
            self,
            action: #selector(showLogoutAlert),
            for: .touchUpInside
        )

        button.tintColor = .lightGray
        return button
    }()

    private var bottomBar: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.isHidden = true
        return view
    }()

    private var matches: [Match] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubviews(
            headerView,
            matchesCollectionView,
            bottomBar,
            headerLabel
        )

        headerView.addSubview(logoutButton)

        matchesCollectionView.backgroundColor = .systemBackground
        matchesCollectionView.delegate = self
        matchesCollectionView.dataSource = self
        matchesCollectionView.register(
            MatchCell.self,
            forCellWithReuseIdentifier: Constants.matchCellId
        )
        showActivityIndicator()
        mainViewPresenter?.viewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        var uiPrevMaxY: CGFloat = 0
        
        headerView.frame = CGRect(
            x: 0, y: 0,
            width: view.bounds.width, height: Constants.headerViewHeight
        )
        uiPrevMaxY += Constants.headerViewHeight
        
        matchesCollectionView.frame = CGRect(
            x: 0, y: uiPrevMaxY,
            width: view.bounds.width,
            height: -uiPrevMaxY + view.bounds.height - Constants.bottomBarHeight
        )
        uiPrevMaxY += matchesCollectionView.frame.height
        
        bottomBar.frame = CGRect(
            x: 0, y: uiPrevMaxY,
            width: view.bounds.width, height: Constants.bottomBarHeight
        )
        
        activityIndicator.center = CGPoint(
            x: view.center.x,
            y: headerView.frame.maxY + 20
        )
        
        headerLabel.frame = CGRect(
            x: 1.5 * Constants.matchCellMargin,
            y: headerView.frame.maxY - 60.0,
            width: view.frame.width,
            height: 40
        )

        logoutButton.frame = CGRect(
            origin: .zero,
            size: CGSize(
                width: Constants.logoutButtonSide,
                height: Constants.logoutButtonSide
            )
        )

        logoutButton.center = CGPoint(
            x: headerLabel.frame.maxX - Constants.logoutButtonSide - 24,
            y: headerLabel.center.y
        )

        layout.invalidateLayout()
    }
    
    private func showActivityIndicator() {
        view.addSubview(activityIndicator)
        matchesCollectionView.fadeOut()
    }
    
    private func hideActivityIndicator() {
        activityIndicator.removeFromSuperview()
        matchesCollectionView.fadeIn()
    }

    @objc private func showLogoutAlert() {
        mainViewPresenter?.showLogoutAlert()
    }
    
}

//MARK: - CollectionView's Delegate & DataSource
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        matches.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = matchesCollectionView.dequeueReusableCell(
            withReuseIdentifier: Constants.matchCellId, for: indexPath
        ) as! MatchCell
        cell.configure(matches[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = MatchViewAssembly.createModule(with: matches[indexPath.row])
        present(vc, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(
            width:  matchesCollectionView.frame.width - 2 * Constants.matchCellMargin,
            height: Constants.matchCellHeight
        )
    }
}

// MARK: - MainView Protocol

protocol MainView: AnyObject {
    func onMatchesChanged(matches: [Match])
    func present(alert: UIAlertController)
}

extension MainViewController: MainView {
    func onMatchesChanged(matches: [Match]) {
        self.matches = matches
        onMainThreadAsync {
            self.matchesCollectionView.reloadData()
            if self.mainViewPresenter?.nextMatchPosition != nil && self.matches.count != 0 {
                self.matchesCollectionView.scrollToItem(at: IndexPath(row: self.mainViewPresenter?.nextMatchPosition ?? 0, section: 0), at: [.top, .centeredHorizontally], animated: false)
            }
            self.hideActivityIndicator()
        }
    }

    func present(alert: UIAlertController) {
        present(alert, animated: true)
    }
}
