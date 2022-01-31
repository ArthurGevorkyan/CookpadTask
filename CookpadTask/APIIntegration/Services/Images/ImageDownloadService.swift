//
//  ImageDownloadService.swift
//  CookpadTask
//
//  Created by Arthur Gevorkyan on 31.01.22.
//

import Foundation
import UIKit

protocol ImageDownloadService {
    func getImage(at imageURL: URL, completion: @escaping (UIImage?, Error?) -> Void) -> URLSessionDataTask?
}
