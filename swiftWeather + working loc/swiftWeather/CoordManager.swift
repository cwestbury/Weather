//
//  CoordManager.swift
//  swiftWeather
//
//  Created by Cameron Westbury on 11/21/15.
//  Copyright © 2015 Cameron Westbury. All rights reserved.
//

import Foundation
import CoreLocation

class CoordManager: NSObject, CLLocationManagerDelegate {
    
    static let sharedInstance = CoordManager()
    
    
    //MARK: - Global Variables
    
    var ReverseGeoCoderSearchedCityName = ""
    let geocoder = CLGeocoder()
    var locationManager: CLLocationManager = CLLocationManager()
    

    
    //MARK: - Methods
    

    func reverseGeocodeCoords(Lat:Double, long:Double){
        let location = CLLocation(latitude: Lat, longitude: long)
        geocoder.reverseGeocodeLocation(location) { (placemark, error) -> Void in
            
            self.ReverseGeoCoderSearchedCityName = placemark!.first!.locality! + ", " + placemark!.first!.ISOcountryCode!
            print("Revloc: \(self.ReverseGeoCoderSearchedCityName)")

            
        }
    }
    
}