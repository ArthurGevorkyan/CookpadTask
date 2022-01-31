//
//  ManagedStep.swift
//  CookpadTask
//
//  Created by Arthur Gevorkyan on 29.01.22.
//

import CoreData

class ManagedStep: NSManagedObject, /*Decodable,*/ Step {
    var textDescription: String {
        return textDescriptionStorage ?? ""
    }
    
    var imageURLs: [String] {
        return imageURLsStorage ?? []
    }
}
