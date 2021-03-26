//
//  H_Stores+CoreDataProperties.swift
//  FindErr
//
//  Created by Dharamvir Yadav on 6/15/20.
//
//

import Foundation
import CoreData


extension H_Stores {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<H_Stores> {
        return NSFetchRequest<H_Stores>(entityName: "H_Stores")
    }

    @NSManaged public var image: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var name: String?
    @NSManaged public var placeid: String?
    @NSManaged public var rating: Int16
    @NSManaged public var timestamp: Date?

}

extension H_Stores : Identifiable {

}
