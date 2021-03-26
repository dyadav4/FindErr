//
//  H_Stores+CoreDataClass.swift
//  FindErr
//
//  Created by Dharamvir Yadav on 6/15/20.
//
//

import Foundation
import CoreData

@objc(H_Stores)
public class H_Stores: NSManagedObject {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        self.timestamp = Date()
    }
}
