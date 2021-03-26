//
//  HistoryTableTableViewController.swift
//  FindErr
//
//  Created by Dharamvir Yadav on 6/15/20.
//

import UIKit

class HistoryTableTableViewController: UITableViewController {
    
    @IBOutlet private weak var historyTableView: UITableView!
    
    var dataStore: DataStore = DataStore()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getVisitedPlaces()
    }
    
    //function to get all the visited places stored in the coredata
    private func getVisitedPlaces() {
        dataStore.getDataFromDB() {
            self.historyTableView.reloadData()
        }
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return dataStore.sectionCount()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataStore.rowsCount(for: section)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = historyTableView.dequeueReusableCell(withIdentifier: "historycell", for: indexPath) as? HomeTableViewCell else {fatalError()}

        // Configure the cell...
        let shop = dataStore.itemAt(indexPath: indexPath)
        cell.shops = shop

        return cell
    }
    
    //go to the detail page once clicked and pass the selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let shop = dataStore.itemAt(indexPath: indexPath)!
        let shopDetailController = ShopDetailViewController()
        shopDetailController.shopDetail = shop
        navigationController?.pushViewController(shopDetailController, animated: true)
    }
    
    //height for the row
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    

}
