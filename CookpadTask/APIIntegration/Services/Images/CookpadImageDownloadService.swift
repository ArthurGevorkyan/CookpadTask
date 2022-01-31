//
//  CookpadImageDownloadService.swift
//  CookpadTask
//
//  Created by Arthur Gevorkyan on 31.01.22.
//

import Foundation
import UIKit

class CookpadImageDownloadService: ImageDownloadService {
    static let `default` = CookpadImageDownloadService()
    
    private init() {
    }
    
    func getImage(at imageURL: URL, completion: @escaping (UIImage?, Error?) -> Void) -> URLSessionDataTask? {
        let imageDownloadTask = URLSession.shared.dataTask(with: imageURL) { data, _, error in
            guard let data = data else {
                completion(nil, error)
                return
            }
            
            let image = UIImage(data: data)
            completion(image, error)
        }
        
        imageDownloadTask.resume()
        return imageDownloadTask
    }
}
