//
//  ShopDetailViewController.swift
//  FindErr
//
//  Created by Dharamvir Yadav on 6/10/20.
//

import UIKit
import MapKit
import MobileCoreServices

class ShopDetailViewController: UIViewController {
    
    deinit { print("ShopDetailViewController memory being reclaimed...") }
    
    @IBOutlet weak var shopNameLabel: UILabel!
    @IBOutlet weak var expectedTravelTimeButton: UIButton!
    @IBOutlet weak var shopImageView: UIImageView!
    @IBOutlet weak var shopMapView: MKMapView!
    
    var shopDetail: Store!
    
    //kept the default address to chicago in case the user decline the location permission
    var userLatitude: Double? = 41.8451714
    var userLongitude: Double? = -87.6700393
    
    //this data will be passed from the previous controller
    var shopLatitude: Double? = nil
    var shopLongitude: Double? = nil
    
    //variable for dataStore
    var dataStore:DataStore = DataStore()
    
    //getting the business location
    var businessLocation: CLLocationCoordinate2D! {
        return createShopLocation(business: shopDetail)
    }
    
    //expected time travel from the userlocation to the shop location
    var expectedTravelTime: TimeInterval? {
        didSet {
            expectedTravelTimeButton.alpha = 1
            guard let time = expectedTravelTime?.toDisplayString() else { return }
            expectedTravelTimeButton.setTitle("Est Travel Time: " + time, for: .normal) //"Est Travel Time: " + time
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBarButtons()
        
        //showing the shopname and image
        self.shopNameLabel.text = shopDetail?.name
        shopImageView.loadImage(url: shopDetail.image)
        // Do any additional setup after loading the view.
        
        //storing the shoplatitude and shoplongitude
        shopLatitude = shopDetail.coordinates?.latitude
        shopLongitude = shopDetail.coordinates?.longitude
        
        shopMapView.delegate = self
        
        //adding the pin on top of user location and shop location
        addingAnnotations()
        
        //getting and calculating the direction between userlocation and shop location
        getDirections()
    }
    
    //this will be used for sharing the shop details
    fileprivate func setupNavigationBarButtons() {
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(handleShareButton))
        ]
    }

    @IBAction func openGoogleMap(){
        
        saveHistory(store: shopDetail)
        
        guard let lat = shopLatitude, let long = shopLongitude  else { return }
        
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {  //if phone has an app
                  if let url = URL(string: "comgooglemaps-x-callback://?saddr=&daddr=\(lat),\(long)&directionsmode=driving") {
                        UIApplication.shared.open(url, options: [:])
                   }
        }else {
            if let urlDestination = URL.init(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(lat),\(long)&directionsmode=driving") {
                UIApplication.shared.open(urlDestination)
            }
        }
    }
    
    
    private func saveHistory(store: Store){
        guard let _ = store.name, let coor = store.coordinates, let _ = coor.latitude, let _ = coor.longitude, let _ = store.id else{return}
        
        dataStore.saveStoreInTheHistory(store: store)
    }
    
    
    
    //share the map location through mail only
    @objc func handleShareButton() {
        
        var items = [AnyObject]()
        let locationTitle = shopDetail.name
        
        guard let shopLat = shopLatitude, let shopLong = shopLongitude else { return }  //showalert
        
        let URLString = "https://maps.apple.com?ll=\(shopLat),\(shopLong)"
        let locationVCardString = [
                "BEGIN:VCARD",
                "VERSION:3.0",
                "PRODID:-//Joseph Duffy//Blog Post Example//EN",
                "N:;\(locationTitle!);;;",
                "FN:\(locationTitle!)",
                "item1.URL;type=pref:\(URLString)",
                "item1.X-ABLabel:map url",
                "END:VCARD"
        ].joined(separator: "\n")
        
        guard let vCardData: NSSecureCoding = locationVCardString.data(using: .utf8) as NSSecureCoding? else {
            return
        }
        
        let vCardActivity = NSItemProvider(item: vCardData, typeIdentifier: kUTTypeVCard as String)
        items.append(vCardActivity)
        
        
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        //only include the mails app
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.postToFacebook, UIActivity.ActivityType.postToTwitter, UIActivity.ActivityType.postToWeibo, UIActivity.ActivityType.message, UIActivity.ActivityType.print, UIActivity.ActivityType.copyToPasteboard,UIActivity.ActivityType.assignToContact,UIActivity.ActivityType.saveToCameraRoll,UIActivity.ActivityType.addToReadingList, UIActivity.ActivityType.postToFlickr, UIActivity.ActivityType.postToVimeo,UIActivity.ActivityType.postToTencentWeibo,UIActivity.ActivityType.airDrop]

        present(activityViewController, animated: true)
    }
    
    //adding the pin on the user and shop location
    func addingAnnotations() {
        //getting their physical address
        shopMapView.getAddress(latitute: userLatitude!, longitude: userLongitude!)
        if shopLatitude != nil && shopLongitude != nil {
            shopMapView.getAddress(latitute: shopLatitude!, longitude: shopLongitude!)
        }
    }
    
    //getting the shop coordinates
    func createShopLocation(business: Store) -> CLLocationCoordinate2D {
        guard let lat = business.coordinates?.latitude, let lon = business.coordinates?.longitude else { return CLLocationCoordinate2D() }
        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
    
    //getting the direction
    func getDirections() {
        let location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: userLatitude!, longitude: userLongitude!)
        
        
        let request = createDirectionsRequest(from: location)
        let directions = MKDirections(request: request)
        
        //calculating the time distance and the direction
        directions.calculate { [unowned self] (response, error) in
            guard let response = response else {
                if let error = error {
                    print("Error:", error.localizedDescription)
                }
                return
            }
            
            let route = response.routes[0]
            self.expectedTravelTime = route.expectedTravelTime
        
            self.shopMapView.addOverlay(route.polyline, level: .aboveRoads)
            self.shopMapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: .init(top: 32, left: 32, bottom: 32, right: 32), animated: true)
        }
    }
    
    
    func createDirectionsRequest(from coordinate: CLLocationCoordinate2D) -> MKDirections.Request {
        
        let startingLocation = MKPlacemark(coordinate: coordinate)
        let destination = MKPlacemark(coordinate: businessLocation)
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startingLocation)
        request.destination = MKMapItem(placemark: destination)

        // Use Transport Type enum
        request.transportType = .automobile
        request.requestsAlternateRoutes = true
        return request
    }
}


// this is used for adding the annotaion for the user and the shop
extension ShopDetailViewController: MKMapViewDelegate {
    private func centreMap(on location: CLLocationCoordinate2D) {
        
        let region = MKCoordinateRegion(center: location, latitudinalMeters: 1000, longitudinalMeters: 1000)
        shopMapView.setRegion(region, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else { fatalError("Polyline Renderer could not be initialized") }
        let renderer = MKPolylineRenderer(overlay: polyline)
        renderer.strokeColor = #colorLiteral(red: 0.05882352941, green: 0.737254902, blue: 0.9764705882, alpha: 1)
        renderer.lineWidth = 4.0
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }

            let identifier = "Annotation"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

            if annotationView == nil {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView!.canShowCallout = true
            } else {
                annotationView!.annotation = annotation
            }

            return annotationView
    }
}
