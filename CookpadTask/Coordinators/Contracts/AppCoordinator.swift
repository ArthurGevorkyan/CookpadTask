//
//  AppCoordinator.swift
//  CookpadTask
//
//  Created by Arthur Gevorkyan on 30.01.22.
//

import UIKit

protocol AppCoordinator: AnyObject {
    var parentCoordinator: AppCoordinator? { get }
    var childCoordinators: [AppCoordinator] { get }
    
    func start()
    func coordinateToRecipes(in: RecipeCollection)
}
