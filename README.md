# CookpadTask
Applicant's sample project for Cookpad by Arthur Gevorkyan

## Environment
1. Language: Swift 5
2. IDE and command-line tools: Xcode 13.2.1 (13C100)
3. 3-rd party dependencies: NONE
4. 3-rd party dependencies manager: N/A
5. Apple technologies used: Foundation, UIKit, CoreData

## Current state of the project 
### Architecture: MVVM with Coordinators and Services.
  1. **Model.** The model layer consists of:
  1.1. The ApplicationDataModel protocol with one of its specialisations - CookpadCoreDataModel. It represents the entire app data storage.
  1.2. Entities defined as protocols (such as RecipeCollection, Recipe, etc.) and their Decodable, CoreData-driven implementations (such as ManagedRecipeCollection, ManagedRecipe, etc.)
  2. **View.** The view layer consists of:
  2.1. Storyboard-defined views (for the sake of simplicity all views are defined in Main.storyboard)
  2.2. View controllers, subclasses of UIViewController which:
     a) connect, configure and interact with their storyboard-defined views
     b) communicate with the View Model
  3. **View Model.** The view model layer is represented with concrete classes (such as CookpadRecipesTableViewModel, CookpadRecipesTableItemViewModel, etc.) 
  View models provide communicate with services and coordinators in order to get data via the provided API and navigate between screens. 
  The binding between views and their view models is implemented with a tiny, well known concept - **Observable** (a.k.a. Box).
  4. **Coordinators.** The coordinators are represented with the AppCoordinator protocol and its storyboard-dependent implementation (CookpadCollectionsStoryboardNavigationCoordinator).
  The current coordinator assumes that a UINavigationController in the root view controller of its storyboard.
  5. **Services.** The services' purpose is to provide JSON and image data from the api. Currently, there is only one JSON service and one image service. 
  They are implemented in CollectionsAPIService and CookpadImageDownloadService, respectively.
  
### UI/UX:
  1. The app is capable of operating in offline mode once some data has been downloaded.
  2. The app consists of 2 screens (Collections and Recipes; implemented as table view controllers) contained in a navigation controller.
  3. The two screens allow for user-initiated data refresh by the refresh controls on their table views.
  
## Future work:
  1. Enhanced error handling and post-error recovery.
  2. Improved abstraction of the coordinators and view models.
  3. SwiftDoc-like documentation.
  4. Unit and UI tests.
  5. App localisation.
  6. Image caching mechanism.
  7. Full API integration.
  8. Complete implementation of the model (Decodable support for User and Step).
  9. On-demand requests to the API with the If-Modified-Since HTTP header (as opposed to per-screen on-load requests).
  10. UITableViewCell separation and reusability improvement.
  
