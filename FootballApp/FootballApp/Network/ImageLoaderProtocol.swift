//
//  ImageLoaderProtocol.swift
//  FootballApp
//
//  Created by Gleb Zavyalov on 11.12.2021.
//

import UIKit

protocol ImageLoaderProtocol {
    func loadImage(with urlString: String?, completion: @escaping (Result<UIImage, Error>) -> Void)
    func cancelLoad(by urlString: String?)
}
