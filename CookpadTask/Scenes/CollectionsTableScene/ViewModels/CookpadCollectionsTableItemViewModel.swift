//
//  CookpadCollectionsTableItemViewModel.swift
//  CookpadTask
//
//  Created by Arthur Gevorkyan on 30.01.22.
//

import Foundation
import UIKit

class CookpadCollectionsTableItemViewModel {
    private(set) var previewImage: Observable<UIImage?>
    private(set) var title: Observable<String>
    private(set) var descriptionText: Observable<String>
    private(set) var recipeCountText: Observable<String>
    
    private var cancellableTasks: [URLSessionDataTask] = []
    private let imageLoader: ImageDownloadService
    
    init(model: RecipeCollection , imageLoader: ImageDownloadService = CookpadImageDownloadService.default) {
        previewImage = Observable(initialValue: nil)
        title = Observable(initialValue: model.title)
        descriptionText = Observable(initialValue: model.textDescription)
        // lacks string localisation
        recipeCountText = Observable(initialValue: String(format: "%d recipes", model.recipeCount))
        self.imageLoader = imageLoader
        
        if let imageURL = URL(string: model.previewImageURLs.first ?? "") {
            if let imageTask = imageLoader.getImage(at: imageURL, completion: { [weak self] image, _ in
                DispatchQueue.main.async {
                    self?.previewImage.value = image
                }
            }) {
                cancellableTasks.append(imageTask)
            }
        }
    }
    
    deinit {
        cancellableTasks.forEach { task in
            task.cancel()
        }
    }
    
}
