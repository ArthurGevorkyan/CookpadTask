//
//  CookpadCollectionsTableViewModel.swift
//  CookpadTask
//
//  Created by Arthur Gevorkyan on 30.01.22.
//

import Foundation

class CookpadCollectionsTableViewModel: ErrorReporter {
    let apiService: CollectionsAPIService
    private var cancellableTasks: [URLSessionDataTask] = []
    let appDataModel: ApplicationDataModel
    private(set) weak var coordinator: CookpadCollectionsStoryboardNavigationCoordinator?
    
    private(set) var itemViewModels: Observable<[CookpadCollectionsTableItemViewModel]> = Observable(initialValue: [])
    private(set) var isDataLoading: Observable<Bool> = Observable(initialValue: false)
    private(set) var loadingError: Observable<Error?> = Observable(initialValue: nil)
    
    private var collectionModels: [RecipeCollection]?
    
    init(apiService: CollectionsAPIService, appDataModel: ApplicationDataModel = CookpadCoreDataModel.`default`, coordinator: CookpadCollectionsStoryboardNavigationCoordinator) {
        self.apiService = apiService
        self.appDataModel = appDataModel
        self.coordinator = coordinator
    }
    
    func loadData() {
        guard isDataLoading.value == false else {
            return
        }
        
        let collectionsRequestTask = apiService.getCollections(completion: { [weak self] success, error in
            DispatchQueue.main.async {
                self?.isDataLoading.value = false
                if !success {
                    self?.loadingError.value = error ?? self?.formReportableError(message: "Unknown error",
                                                                                  code: ErrorCode.viewModelLoadingFailure.rawValue)
                } else {
                    let models = self?.appDataModel.fetchRecipeCollections() ?? []
                    self?.collectionModels = models
                    self?.itemViewModels.value = self?.prepareItemViewModels(from: models) ?? []
                }
            }
        })
        isDataLoading.value = true
        collectionsRequestTask?.resume()
        
        if let task = collectionsRequestTask {
            cancellableTasks.append(task)
        }
    }
    
    func showCollectionRecipies(at index: Int) {
        guard let collections = collectionModels,
                0..<collections.count ~= index,
                let collection = collectionModels?[index] else {
            return
        }
        coordinator?.coordinateToRecipes(in: collection)
    }
    
    private func prepareItemViewModels(from models: [RecipeCollection]) -> [CookpadCollectionsTableItemViewModel] {
        let itemViewModels = models.map { model in
            CookpadCollectionsTableItemViewModel(model: model)
        }
        
        return itemViewModels
    }
    
    deinit {
        cancellableTasks.forEach { task in
            task.cancel()
        }
    }
}
