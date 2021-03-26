//
//  ViewController.swift
//  FindErr
//
//  Created by Dharamvir Yadav on 6/10/20.
//

import UIKit
import Foundation
import MapKit
import CoreLocation


class HomeTableViewController: UITableViewController{
    
    //outlets
    @IBOutlet weak var storesTableView: UITableView!
    
    //location based initialization
    let locationManager = CLLocationManager()
    var userLatitute: Double? = nil
    var userLongitude: Double? = nil
    var searchTerm: String = ""
    
    let ApiServiceManager: ApiServiceProtocol = ApiService.shared()
    
    //array to store all the shops
    var allStores: [Store] = [Store]()
    
    //variable for searchcontroller
    let searchController = UISearchController(searchResultsController: nil)
    
    //view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupLocationManger()
        setUpSearchController()
        
    }
    
    // setup the location manager
    private func setupLocationManger() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    //setting up all the properties for the searchcontroller
    private func setUpSearchController(){
        searchController.searchBar.delegate = self
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = .search
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    //function to fetch all the shops. this will called once we have the user lcoation
    private func fetchShops() {
        
        guard let userLat = userLatitute, let userLong = userLongitude else { return } //show alert
        
        ApiServiceManager.fetchShopsWith(router: .getAllShops(searchterm: searchTerm, latitude: userLat, longitude: userLong)) { [weak self] (result) in
            switch result{
            case .success(let data):
                    
                self?.allStores = []
                self?.allStores = data
                
                DispatchQueue.main.async {
                    self?.storesTableView.reloadData()
                }
            case .failure(error: let error):
                print(error ?? "Error while fetching Stores")
            }
        }
    }
}

// CLLocationManagerDelegate methods
extension HomeTableViewController: CLLocationManagerDelegate {
    //looking for the permission if granted by the user
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
            //user granted the location access
            case .authorizedAlways, .authorizedWhenInUse:
                locationManager.requestLocation()
            case .notDetermined:
                /// Request permission to use location services
                locationManager.requestWhenInUseAuthorization()
            case .denied, .restricted:
                //user has denied the access. in this case, simply fetch the shops based on chicago location as this is my favorite location
                //show alert
                break
            default:
                break
        }
    }
    
    // if the location has been provided, then get the forst location and fetch the shops and user region on the map
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation = locations[0] as CLLocation
        userLatitute = userLocation.coordinate.latitude
        userLongitude = userLocation.coordinate.longitude
        
        fetchShops()
    }
    
    //handle the error
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error is \(error)")
    }
}

//handling the tableview number of rows and the ui
extension HomeTableViewController {
    
    //number of section. it should be 1
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //number of rows for the tableview
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allStores.count
    }
    
    //cell ui based on the data.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = storesTableView.dequeueReusableCell(withIdentifier: "storecell", for: indexPath) as? HomeTableViewCell else {fatalError()}
        cell.shops = allStores[indexPath.row]
        return cell
    }
    
    //go to the detail page once clicked and pass the selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var shop: Store
        shop = allStores[indexPath.row]
        let shopDetailController = ShopDetailViewController()
        shopDetailController.shopDetail = shop
        navigationController?.pushViewController(shopDetailController, animated: true)
    }
    
    //height for the row
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

extension HomeTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchTerm = searchBar.text ?? ""
        fetchShops()
    }
}

