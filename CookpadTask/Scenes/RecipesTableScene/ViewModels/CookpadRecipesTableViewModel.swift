//
//  CookpadRecipesTableViewModel.swift
//  CookpadTask
//
//  Created by Arthur Gevorkyan on 31.01.22.
//

import Foundation

class CookpadRecipesTableViewModel: ErrorReporter {
    let apiService: CollectionsAPIService
    private var cancellableTasks: [URLSessionDataTask] = []
    let appDataModel: ApplicationDataModel
    private(set) weak var coordinator: CookpadCollectionsStoryboardNavigationCoordinator?
    private let collectionID: Int32
    
    private(set) var itemViewModels: Observable<[CookpadRecipesTableItemViewModel]> = Observable(initialValue: [])
    private(set) var isDataLoading: Observable<Bool> = Observable(initialValue: false)
    private(set) var loadingError: Observable<Error?> = Observable(initialValue: nil)
    
    init(collectionID: Int32,
         apiService: CollectionsAPIService,
         appDataModel: ApplicationDataModel = CookpadCoreDataModel.`default`,
         coordinator: CookpadCollectionsStoryboardNavigationCoordinator) {
        self.collectionID = collectionID
        self.apiService = apiService
        self.appDataModel = appDataModel
        self.coordinator = coordinator
    }
    
    func loadData() {
        guard isDataLoading.value == false else {
            return
        }
        
        let recipesRequestTask = apiService.getRecipes(byCollectionID: collectionID, completion: { [weak self] success, error in
            DispatchQueue.main.async {
                self?.isDataLoading.value = false
                if !success {
                    self?.loadingError.value = error ?? self?.formReportableError(message: "Unknown error",
                                                                                  code: ErrorCode.viewModelLoadingFailure.rawValue)
                } else {
                    if let collectionID = self?.collectionID,
                       let model = self?.appDataModel.fetchRecipeCollection(withID: collectionID) {
                        self?.itemViewModels.value = self?.prepareItemViewModels(from: model.recipes) ?? []
                    }
                }
            }
        })
        isDataLoading.value = true
        recipesRequestTask?.resume()
        
        if let task = recipesRequestTask {
            cancellableTasks.append(task)
        }
    }
    
    private func prepareItemViewModels(from models: [Recipe]) -> [CookpadRecipesTableItemViewModel] {
        let itemViewModels = models.map { model in
            CookpadRecipesTableItemViewModel(model: model)
        }
        
        return itemViewModels
    }
    
    deinit {
        cancellableTasks.forEach { task in
            task.cancel()
        }
    }
}
