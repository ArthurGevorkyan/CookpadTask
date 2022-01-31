//
//  ManagedRecipeCollection.swift
//  CookpadTask
//
//  Created by Arthur Gevorkyan on 29.01.22.
//

import CoreData

class ManagedRecipeCollection: NSManagedObject, Decodable {
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case titleStorage = "title"
        case textDescriptionStorage = "description"
        case recipeCount = "recipe_count"
        case previewImageURLsStorage = "preview_image_urls"
    }
    
    required convenience init(from decoder: Decoder) throws {
        let context = try decoder.managedObjectContext()
        self.init(entity: Self.entity(), insertInto: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int32.self, forKey: .id)
        titleStorage = try container.decode(String.self, forKey: .titleStorage)
        textDescriptionStorage = try container.decode(String.self, forKey: .textDescriptionStorage)
        recipeCount = try container.decode(Int32.self, forKey: .recipeCount)
        previewImageURLsStorage = try container.decode([String].self, forKey: .previewImageURLsStorage)
    }
}

// MARK: - RecipeCollection compliance
extension ManagedRecipeCollection: RecipeCollection {
    var title: String {
        return titleStorage ?? ""
    }
    
    var textDescription: String {
        return textDescriptionStorage ?? ""
    }
    
    var previewImageURLs: [String] {
        return previewImageURLsStorage ?? []
    }
    
    var recipes: [Recipe] {
        return recipesRelationship?.array as? [Recipe] ?? []
    }
}
