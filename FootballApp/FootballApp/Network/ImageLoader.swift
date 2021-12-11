//
//  ImageLoader.swift
//  FootballApp
//
//  Created by Gleb Zavyalov on 11.12.2021.
//

import UIKit

class ImageLoader: ImageLoaderProtocol {
    private let loadedImages = NSCache<NSURL, UIImage>()
    private var runningRequests = [URL: URLSessionDataTask]()
    
    func loadImage(with urlString: String?, completion: @escaping (Result<UIImage, Error>) -> Void) {
        guard let url = urlString?.url else {
            return completion(.failure(NSError()))
        }
        
        if let image = loadedImages.object(forKey: url as NSURL) {
            return completion(.success(image))
        }
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: {
            (data, response, error) in
            defer { self.runningRequests.removeValue(forKey: url) }
            
            if let error = error {
                guard (error as NSError).code == NSURLErrorCancelled else {
                    debugPrint(error)
                    return completion(.failure(error))
                }
                return completion(.failure(error))
            }
            
            if let data = data, let image = UIImage(data: data) {
                self.loadedImages.setObject(image, forKey: url as NSURL)
                return completion(.success(image))
            }
            
        })
        
        task.resume()
        runningRequests[url] = task
    }
    
    private func cancelLoad(by url: URL) {
        runningRequests[url]?.cancel()
        runningRequests.removeValue(forKey: url)
    }
    
    func cancelLoad(by urlString: String?) {
        guard let url = urlString?.url else { return }
        cancelLoad(by: url)
    }
    
}
