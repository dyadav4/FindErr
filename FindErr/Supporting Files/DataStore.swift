//
//  DataStore.swift
//  FindErr
//
//  Created by Dharamvir Yadav on 6/10/20.
//

import Foundation
import CoreData

//to take care of the data stored locally

class DataStore: NSObject{
    
    let coreDataManager = CoreDataManager.shared()
    
//    let ApiServiceManager: ApiServiceProtocol
//    private weak var uiUpdater: UpdateUIProtocol!
    
    //fetchedResultsController Variable
    lazy var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "H_Stores")

        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.coreDataManager.managedContext, sectionNameKeyPath: nil, cacheName: nil)

        return frc
    }()
    
    //storing the visited place in the coredata
    func saveStoreInTheHistory(store: Store){
        self.coreDataManager.prepare(dataForSaving: store)
    }
    
    func getDataFromDB(completion: () -> Void){
        do {
            try fetchedResultsController.performFetch()
            completion()
        }catch let err{
            print(err.localizedDescription)
        }
    }
    
}

//implementing required methods of DataStoreProtocol to handle tableview
extension DataStore: DataStoreProtocol{

    func sectionCount() ->Int{
        guard let sections = self.fetchedResultsController.sections else {
            return 0
        }
        return sections.count
    }

    func rowsCount(for section:Int) -> Int{
        guard let sections = self.fetchedResultsController.sections else {
            return 0
        }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }

    func itemAt(indexPath: IndexPath) -> Store?{

        guard let shop = self.fetchedResultsController.object(at: indexPath) as? H_Stores else{
            return nil
        }

        let store = Store(id: shop.placeid, name: shop.name, image: shop.image, coordinates: Coordinate(latitude: shop.latitude, longitude: shop.longitude))

        return store
    }

}
