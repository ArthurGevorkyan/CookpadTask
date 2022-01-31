//
//  ManagedRecipe.swift
//  CookpadTask
//
//  Created by Arthur Gevorkyan on 29.01.22.
//

import CoreData

class ManagedRecipe: NSManagedObject, Decodable {
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case titleStorage = "title"
        case storyStorage = "story"
        case imageURL = "image_url"
        case publishedAtStorage = "published_at"
        case ingredientsStorage = "ingredients"
        
//        case userRelationship = "user"
//        case stepsRelationship = "steps"
    }
    
    
    required convenience init(from decoder: Decoder) throws {
        let context = try decoder.managedObjectContext()
        self.init(entity: Self.entity(), insertInto: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int32.self, forKey: .id)
        titleStorage = try container.decode(String.self, forKey: .titleStorage)
        storyStorage = try container.decode(String.self, forKey: .storyStorage)
        imageURL = try container.decodeIfPresent(String.self, forKey: .imageURL)
        publishedAtStorage = try container.decode(String.self, forKey: .publishedAtStorage)
        ingredientsStorage = try container.decode([String].self, forKey: .ingredientsStorage)
        
#warning("Incomplete implementation")
        // user and steps
    }
}

// MARK: - Recipe compliance
extension ManagedRecipe: Recipe {
    var user: User? {
        return userRelationship
    }
    
    var steps: [Step] {
        return (stepsRelationship?.array as? [Step]) ?? []
    }
    
    var title: String {
        return titleStorage ?? ""
    }
    
    var story: String {
        return storyStorage ?? ""
    }
    
    var publishedAt: String {
        return publishedAtStorage ?? ""
    }
    
    var ingredients: [String] {
        return ingredientsStorage ?? []
    }
}
