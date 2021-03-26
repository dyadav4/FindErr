//
//  CoreDataManager.swift
//  FindErr
//
//  Created by Dharamvir Yadav on 6/10/20.
//

import Foundation
import CoreData

public class CoreDataManager {
    // MARK: - Core Data stack
    
    private init() {}
    public static let _shared = CoreDataManager()
    
    class func shared() -> CoreDataManager {
        return _shared
    }
    
    lazy var managedContext = {
        return self.persistentContainer.viewContext
    }()
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "FindErr")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            
            //Mergepolicy is needed for avoiding the error when updating the already same attribute by shopid key
            container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    //save the new records
    func prepare(dataForSaving: Store){
        _ = self.createEntityFrom(store: dataForSaving)
        saveContextInBackground()
    }
    
    //create the record for the entity
    private func createEntityFrom(store: Store) -> H_Stores?{
        guard let id = store.id, let name = store.name, let image = store.image, let coordinates = store.coordinates, let latitude = coordinates.latitude, let longitude = coordinates.longitude else {
            return nil
        }
        
        let shop = H_Stores(context: self.managedContext)
        
        shop.placeid = id
        shop.name = name
        shop.image = image
        shop.latitude = latitude
        shop.longitude = longitude
        shop.rating = 4
        
        return shop
    }

    // MARK: - Core Data Saving support
    func saveContext() {
        let context = self.managedContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    //if wants to save the record in background
    func saveContextInBackground() {
        persistentContainer.performBackgroundTask { (context) in
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }
        
    }
    
    
    
//    func isShopStoredLocall(id: String, entityName: String, completion: @escaping (Bool) -> Void){
//        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
//
//        let predicate = NSPredicate(format: "id == %@", id)
//        request.predicate = predicate
//
//        do {
//            let count = try persistentContainer.viewContext.count(for: request)
//            if count > 0 {
//                completion(true)
//            }else{
//                completion(false)
//            }
//        }catch let error as NSError{
//            completion(false)
//            print(error)
//        }
//
//    }
    
//    func isShopStoredLocally(id: String, entityName: String) -> Bool {
//        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
//        
//        let predicate = NSPredicate(format: "id == %@", id)
//        request.predicate = predicate
//        
//        do {
//            let count = try persistentContainer.viewContext.count(for: request)
//            if count > 0 {
//                return true
//            }else{
//                return false
//            }
//        }catch let error as NSError{
//            print(error)
//        }
//    }
    
//    func fetch<T: NSManagedObject>(_ type: T.Type, completion: @escaping ([T]) -> Void){
//        let request = NSFetchRequest<T>(entityName: String(describing: type))
//        do {
//            let result = try managedContext.fetch(request)
//            completion(result)
//        }catch {
//            print(error)
//            completion([])
//        }
//    }
    
//    func getAllStoresWith100Miles(_ entityName: String) -> [AnyObject]?{
//        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
//        let result: [AnyObject]?
//        do {
//            result = try persistentContainer.viewContext.fetch(request)
//
//        }catch let error as NSError{
//            print(error)
//            result = nil
//        }
//        return result
//    }
}


