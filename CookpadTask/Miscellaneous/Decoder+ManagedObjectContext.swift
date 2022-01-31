//
//  DecodableManagedObject.swift
//  CookpadTask
//
//  Created by Arthur Gevorkyan on 29.01.22.
//

import CoreData

extension CodingUserInfoKey {
   static let context = CodingUserInfoKey(rawValue: "context")
}

extension Decoder {
    func managedObjectContext() throws -> NSManagedObjectContext {
        guard let contextKey = CodingUserInfoKey.context,
              let context = userInfo[contextKey] as? NSManagedObjectContext else {
                  let errorInfo = [NSDebugDescriptionErrorKey : "Context not found in \(#function)"]
                  throw NSError(domain: "\(type(of: self))",
                                code: ErrorCode.decoderContextMissing.rawValue,
                                userInfo: errorInfo)
              }
        return context
    }
}
