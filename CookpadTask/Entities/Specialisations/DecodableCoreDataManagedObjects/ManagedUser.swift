//
//  ManagedUser.swift
//  CookpadTask
//
//  Created by Arthur Gevorkyan on 29.01.22.
//

import CoreData

class ManagedUser: NSManagedObject, /*Decodable,*/ User {
    var name: String {
        return nameStorage ?? ""
    }
}
