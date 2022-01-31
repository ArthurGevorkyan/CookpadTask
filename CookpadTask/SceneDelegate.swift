//
//  SceneDelegate.swift
//  CookpadTask
//
//  Created by Arthur Gevorkyan on 28.01.22.
//

import UIKit
import OSLog

class SceneDelegate: UIResponder, UIWindowSceneDelegate, ErrorReporter {

    var window: UIWindow?
    private(set) var navigationCoordinator: AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

//    func
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        if navigationCoordinator == nil {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let navigationController = window?.rootViewController as? UINavigationController else {
                let error = formFatalError(message: "App main window is missing (or lacking a navigation controller)",
                                           code: ErrorCode.invalidAppWindowState.rawValue)
                debugPrint(error)
                return
            }
            navigationCoordinator = CookpadCollectionsStoryboardNavigationCoordinator(parentCoordinator: nil,
                                                                              navigationController: navigationController,
                                                                              storyboard: storyboard)
            navigationCoordinator?.start()
        }
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        do {
            try CookpadCoreDataModel.`default`.savePendingChanges()
        } catch let error {
            debugPrint(formFatalError(message: error.localizedDescription,
                                      code: ErrorCode.dataPersistenceFailure.rawValue))
        }
    }
}

