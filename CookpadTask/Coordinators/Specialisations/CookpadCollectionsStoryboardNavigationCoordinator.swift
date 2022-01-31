//
//  CookpadNavigationAppCoordinator.swift
//  CookpadTask
//
//  Created by Arthur Gevorkyan on 30.01.22.
//
import UIKit

class CookpadCollectionsStoryboardNavigationCoordinator: AppCoordinator {
    
    private(set) weak var parentCoordinator: AppCoordinator?
    let childCoordinators: [AppCoordinator]
    
    private let navigationController: UINavigationController
    private let storyboard: UIStoryboard
    private let apiService: CollectionsAPIService
    
    func start() {
        let collectionsViewModel = CookpadCollectionsTableViewModel(apiService: apiService,
                                                                    coordinator: self)
        let collectionsViewController = storyboard.instantiateViewController(identifier: "CollectionsTable") { coder in
            CookpadCollectionsTableViewController(coder: coder, viewModel: collectionsViewModel)
        }
        navigationController.viewControllers = [collectionsViewController]
    }
    
    func coordinateToRecipes(in collection: RecipeCollection) {
        let recipesViewModel = CookpadRecipesTableViewModel(collectionID: collection.id,
                                                            apiService: apiService,
                                                            coordinator: self)
        let recipiesController = storyboard.instantiateViewController(identifier: "RecipesTable") { coder in
            CookpadRecipesTableViewController(coder: coder, viewModel: recipesViewModel)
        }
        navigationController.pushViewController(recipiesController, animated: true)
    }
    
    init(parentCoordinator: AppCoordinator?,
         childCoordinators: [AppCoordinator] = [],
         navigationController: UINavigationController,
         storyboard: UIStoryboard,
         apiService: CollectionsAPIService = CollectionsAPIService(applicationDataModel: CookpadCoreDataModel.default)) {
        self.parentCoordinator = parentCoordinator
        self.childCoordinators = childCoordinators
        self.navigationController = navigationController
        self.storyboard = storyboard
        self.apiService = apiService
    }
}
