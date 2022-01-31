//
//  CookpadCoreDataModel.swift
//  CookpadTask
//
//  Created by Arthur Gevorkyan on 28.01.22.
//

import CoreData

final class CookpadCoreDataModel: ErrorReporter {
    
    private init() {
    }
    
// MARK: CoreData stack
    private static let persistentContainerName = "CookpadTask"
    private var initialisationState: CookpadCoreDataInitialisationState = .unknown
    
    private lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: CookpadCoreDataModel.persistentContainerName)
        
        initialisationState = .pending
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            
            if let error = error as NSError? {
                let errorToLog = self.formFatalError(message: error.localizedDescription, code: 111)
                debugPrint(errorToLog)
                self.initialisationState = .failed(error: error)
            } else {
                // the view context should blindly accept data from the store
                container.viewContext.mergePolicy = NSOverwriteMergePolicy
                self.initialisationState = .successful
            }
            
        })
        return container
    }()
}

// MARK: - DataModel compliance
extension CookpadCoreDataModel: ApplicationDataModel {
    static let `default` = CookpadCoreDataModel()
    
    func savePendingChanges() throws {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            try context.save()
        }
    }
    
    func insertRecipeCollections(from data: Data, completion: @escaping (Error?) -> Void) {
        let context = newBackgroundCoreDataContext()
        insertData(data,
                   ofType: [ManagedRecipeCollection].self,
                   context: context,
                   completion: { _, error in
            context.perform {
                do {
                    try context.save()
                    completion(nil)
                } catch let error {
                    completion(error)
                }
            }
        })
    }
    
    func insertRecipesIntoCollection(withID collectionID: Int32, from data: Data, completion: @escaping (Error?) -> Void) {
        
        let context = newBackgroundCoreDataContext()
        let predicate = NSPredicate(format: "id == %d", collectionID)
        let collection: ManagedRecipeCollection? = fetchEntity(predicate: predicate, context: context)
        
        insertData(data, ofType: [ManagedRecipe].self, context: context) { insertedRecipes, error in
            guard error == nil else {
                completion(error)
                return
            }
            
            context.perform {
                do {
                    if let insertedRecipes = insertedRecipes {
                        insertedRecipes.forEach { recipe in
                            collection?.addToRecipesRelationship(recipe)
                        }
                        try context.save()
                    }
                    completion(nil)
                } catch let error {
                    completion(error)
                }
            }
        }
        
    }
    
    func fetchRecipeCollections() -> [RecipeCollection] {
        let fetchRequest = ManagedRecipeCollection.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let fetchedCollections = try? persistentContainer.viewContext.fetch(fetchRequest)
        return fetchedCollections ?? []
    }
    
    func fetchRecipeCollection(withID collectionID: Int32) -> RecipeCollection? {
        let predicate = NSPredicate(format: "id == %d", collectionID)
        let collection: ManagedRecipeCollection? = fetchEntity(predicate: predicate, context: persistentContainer.viewContext)
        
        return collection
    }
}

// MARK: - DecodableManagedObject support
private extension CookpadCoreDataModel {
    
    func newBackgroundCoreDataContext() -> NSManagedObjectContext {
        let context = persistentContainer.newBackgroundContext()
        context.mergePolicy = NSOverwriteMergePolicy
        return context
    }
    
    func insertData<T : Decodable>(_ data: Data, ofType: T.Type, context: NSManagedObjectContext, completion: @escaping (T?, Error?) -> Void) {
        
        let decoder = JSONDecoder()
        
        if let contextUserInfoKey = CodingUserInfoKey.context {
            decoder.userInfo[contextUserInfoKey] = context
        }
        
        guard case .successful = initialisationState else {
            let message = "Invalid persistent container state: \(initialisationState) in \(#function)"
            let error = formFatalError(message: message,
                                       code: ErrorCode.invalidPersistentContainerState.rawValue)
            completion(nil, error)
            return
        }

        context.perform {
            do {
                let decoded = try decoder.decode(T.self, from: data)
                completion(decoded, nil)
            } catch let error {
                completion(nil, error)
            } 
        }
    }
    
    func fetchEntity<T: NSManagedObject>(predicate: NSPredicate, context: NSManagedObjectContext) -> T? {
        let fetchRequest = T.fetchRequest()
        fetchRequest.predicate = predicate
        fetchRequest.fetchLimit = 1
        let entity = (try? context.fetch(fetchRequest))?.first
        return entity as? T
    }
}
