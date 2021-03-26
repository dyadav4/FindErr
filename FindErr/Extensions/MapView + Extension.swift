//
//  MapView + Extension.swift
//  FindErr
//
//  Created by Dharamvir Yadav on 6/10/20.
//

import Foundation
import MapKit

//extension to get the physical address for coordinates
extension MKMapView {
    func getAddress(latitute: CLLocationDegrees, longitude: CLLocationDegrees){
        
        
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: latitute, longitude: longitude)

        
        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in

            if (error != nil){
                print("reverse geodcode fail: \(error!.localizedDescription)")
            }

            guard let placemarks = placemarks else{
                return
            }

            if placemarks.count > 0 {
                var currentStr = ""
                let placeMark = placemarks[0]

                if let placeMarkName = placeMark.name{
                    currentStr += placeMarkName + ", "
                }
                
                if let placeMarkLocality = placeMark.locality{
                    currentStr += placeMarkLocality + ", "
                }
                
                if let placeMarkAdministariveArea = placeMark.administrativeArea{
                    currentStr += placeMarkAdministariveArea + ", "
                }
                
                if let placeMarkCountry = placeMark.country{
                    currentStr += placeMarkCountry + ", "
                }
                
                if let placeMarkPostalCode = placeMark.postalCode{
                    currentStr += placeMarkPostalCode + ", "
                }
                
                currentStr = currentStr.trimmingCharacters(in: .whitespaces)
                if let lastchar = currentStr.last {
                    if [",", ".", "-", "?"].contains(lastchar) {
                        currentStr = String(currentStr.dropLast())
                    }
                }
                
                let locationAnnotation = MKPointAnnotation()
                locationAnnotation.title = currentStr
                locationAnnotation.coordinate = CLLocationCoordinate2D(latitude: latitute, longitude: longitude)
                self.addAnnotation(locationAnnotation)
                
                
                
//                completion(currentStr)
            }
        }
    }
}


