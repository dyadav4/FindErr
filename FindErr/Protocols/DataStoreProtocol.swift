//
//  DataStoreProtocol.swift
//  FindErr
//
//  Created by Dharamvir Yadav on 6/11/20.
//

import Foundation

//to handle the tablecview if data is coming for coredata
protocol DataStoreProtocol {
    associatedtype T
    func rowsCount(for section:Int) -> Int
    func itemAt(indexPath: IndexPath) -> T?
}

//update the ui once the data is being received
protocol UpdateUIProtocol: class {
    func updateUI(data: [Store])
}
