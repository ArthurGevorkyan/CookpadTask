//
//  DataService.swift
//  CookpadTask
//
//  Created by Arthur Gevorkyan on 28.01.22.
//

import Foundation

protocol ApplicationDataModel {
    static var `default`: Self { get }
    
    func savePendingChanges() throws
    
    func insertRecipeCollections(from data: Data, completion: @escaping (Error?) -> Void)
    func insertRecipesIntoCollection(withID collectionID: Int32, from data: Data, completion: @escaping (Error?) -> Void)
    
    func fetchRecipeCollections() -> [RecipeCollection]
    func fetchRecipeCollection(withID collectionID: Int32) -> RecipeCollection?
}
