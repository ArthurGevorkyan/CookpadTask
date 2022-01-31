//
//  CollectionsService.swift
//  CookpadTask
//
//  Created by Arthur Gevorkyan on 29.01.22.
//

import Foundation

final class CollectionsAPIService: BaseAPIService {
    let applicationDataModel: ApplicationDataModel
    
    init(applicationDataModel: ApplicationDataModel) {
        self.applicationDataModel = applicationDataModel
        super.init(path: "/api/collections/")
    }
    
    func getCollections(completion: @escaping (Bool, Error?) -> Void) -> URLSessionDataTask? {
        guard let url = URL(string: endpoint) else {
            let message = "Unable to create the URL for the request in \(#function)"
            let error = formFatalError(message: message,
                                       code: ErrorCode.invalidRequestURL.rawValue)
            completion(false, error)
            return nil
        }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if self?.validateHTTPGetResponse(response, completion: completion) == true {
                if let data = data,
                    self?.validateHTTPGetResponseData(data, completion: completion) == true {
                    self?.applicationDataModel.insertRecipeCollections(from: data) { error in
                        completion(error == nil, error)
                    }
                }
            }
        }
        task.resume()
        return task
    }
    
    func getRecipes(byCollectionID collectionID: Int32, completion: @escaping (Bool, Error?) -> Void) -> URLSessionDataTask? {

        guard let url = URL(string: endpoint)?.appendingPathComponent("\(collectionID)/recipes") else {
            let message = "Unable to create the URL for the request in \(#function)"
            let error = formFatalError(message: message,
                                       code: ErrorCode.invalidRequestURL.rawValue)
            completion(false, error)
            return nil
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if self?.validateHTTPGetResponse(response, completion: completion) == true {
                if let data = data,
                    self?.validateHTTPGetResponseData(data, completion: completion) == true {
                    self?.applicationDataModel.insertRecipesIntoCollection(withID: collectionID, from: data) { error in
                        completion(error == nil, error)
                    }
                }
            }
        }
        task.resume()
        return task
    }
    
    
    private func validateHTTPGetResponseData(_ data: Data?, completion: (Bool, Error?) -> Void) -> Bool {
        guard let data = data, data.count > 0 else {
            let error = formReportableError(message: "Missing HTTP response data in \(#function)",
                                            code: ErrorCode.responseDataMissing.rawValue)
            completion(false, error)
            return false
        }
        return true
    }
    
    private func validateHTTPGetResponse(_ response: URLResponse?, completion: (Bool, Error?) -> Void) -> Bool {
        guard let httpResponse = response as? HTTPURLResponse else {
            let error = formReportableError(message: "Missing HTTP response in \(#function)",
                                            code: ErrorCode.invalidResponse.rawValue)
            completion(false, error)
            return false
        }
        
        guard httpResponse.statusCode == 200 else {
            let error = formReportableError(message: "Unexpected HTTP code in \(#function)",
                                                  code: httpResponse.statusCode)
            completion(false, error)
            return false
        }
        
        return true
    }
}


