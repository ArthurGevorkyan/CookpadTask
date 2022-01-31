//
//  CookpadRecipesTableItemViewModel.swift
//  CookpadTask
//
//  Created by Arthur Gevorkyan on 31.01.22.
//

import Foundation
import UIKit

class CookpadRecipesTableItemViewModel {
    
    private(set) var title: Observable<String>
    private(set) var storyText: Observable<String>
    private(set) var ingredientsCountText: Observable<String>
    private(set) var publishedAtText: Observable<String>
    
    private(set) var previewImage: Observable<UIImage?>
    
    private var cancellableTasks: [URLSessionDataTask] = []
    private let imageLoader: ImageDownloadService
    
    init(model: Recipe , imageLoader: ImageDownloadService = CookpadImageDownloadService.default) {
        
        title = Observable(initialValue: model.title)
        storyText = Observable(initialValue: model.story)
        
        ingredientsCountText = Observable(initialValue: Self.ingredientsText(from: model.ingredients))
        publishedAtText = Observable(initialValue: Self.publishedAtText(from: model.publishedAt))
        previewImage = Observable(initialValue: nil)
        
        self.imageLoader = imageLoader
        
        if let imageURL = URL(string: model.imageURL ?? "") {
            if let imageTask = imageLoader.getImage(at: imageURL, completion: { [weak self] image, _ in
                DispatchQueue.main.async {
                    self?.previewImage.value = image
                }
            }) {
                cancellableTasks.append(imageTask)
            }
        }
    }
    
    private static func ingredientsText(from ingredientsList: [String]) -> String {
        let ingredientsCount = ingredientsList.reduce(0) { partialResult, _ in
            partialResult + 1
        }
        // lacks string localisation
        return String(format: "%d ingredients", ingredientsCount)
    }
    
    private static func publishedAtText(from dateString: String) -> String {
        let inputFormatter = ISO8601DateFormatter()
        let outputFormatter = DateFormatter()
        outputFormatter.dateStyle = .medium
        guard let date = inputFormatter.date(from: dateString) else {
            return ""
        }
        
        // lacks localisation
        let prettyDateString = outputFormatter.string(from: date)
        return "Published on \(prettyDateString)"
    }
    
    deinit {
        cancellableTasks.forEach { task in
            task.cancel()
        }
    }
    
}
