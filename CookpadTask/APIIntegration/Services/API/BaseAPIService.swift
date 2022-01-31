//
//  BaseAPIService.swift
//  CookpadTask
//
//  Created by Arthur Gevorkyan on 29.01.22.
//

import Foundation

class BaseAPIService: ErrorReporter {
    
    let rootEndpoint: String
    let path: String
    
    var endpoint: String {
        return rootEndpoint + path
    }
    
    init(rootEndpoint: String = "https://cookpad.github.io/global-mobile-hiring", path: String) {
        self.rootEndpoint = rootEndpoint
        self.path = path
    }
}
