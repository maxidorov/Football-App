//
//  SearchHeaderView.swift
//  FootballApp
//
//  Created by Gleb Zavyalov on 09.12.2021.
//

import UIKit

class SearchHeaderView: UIView {
    static let headerHeight: CGFloat = UIApplication.shared.statusBarFrame.height + 50
    let searchTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Search"
        tf.backgroundColor = .systemBackground
        return tf
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemGreen
        
        let viewSubview = [
            searchTextField,
        ]
        for v in viewSubview { self.addSubview(v) }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        searchTextField.frame = CGRect(
            x: 16, y: UIApplication.shared.statusBarFrame.height + 7.5,
            width: self.frame.size.width - 32, height: 30
        )
    }

}
