//
//  RecipeCollection.swift
//  CookpadTask
//
//  Created by Arthur Gevorkyan on 29.01.22.
//

protocol RecipeCollection {
    var id: Int32 { get }
    var title: String { get }
    var textDescription: String { get }
    var recipeCount: Int32 { get }
    var previewImageURLs: [String] { get }
    var recipes: [Recipe] { get }
}
