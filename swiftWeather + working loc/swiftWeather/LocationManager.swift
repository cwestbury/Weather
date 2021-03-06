//
//  LocationManager.swift
//  swiftWeather
//
//  Created by Cameron Westbury on 11/19/15.
//  Copyright © 2015 Cameron Westbury. All rights reserved.
//

import Foundation
import CoreLocation


class LocationManager: NSObject, CLLocationManagerDelegate {
    
    static let sharedInstance = LocationManager()
    
    var locationManager: CLLocationManager = CLLocationManager()
    var userLocationCoordinates = CLLocationCoordinate2D()
    var networkManger = NetworkManager.sharedInstance
    var dataManager = DataManager.sharedInstance
    var cityName = "" as String
    var DataCityName = "" as String
    

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        userLocationCoordinates = CLLocationCoordinate2D(latitude: locations.last!.coordinate.latitude, longitude:locations.last!.coordinate.longitude)
        print("Loc Manager locations = \(locValue.latitude) \(locValue.longitude)")
        self.locationManager.stopUpdatingLocation()
        let location = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            print(location)
            
            if error != nil {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
                return
            }
            if placemarks!.count > 0 {
                let pm = placemarks![0]
                print(pm.locality!)
                self.cityName = pm.locality!
                
                dispatch_async(dispatch_get_main_queue()){
                    NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "recievedLocationFromUser", object: nil))
                }
                
            } else {
                print("Problem with the data received from geocoder")
            }
        })
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
            print("Loc Manager Error \(error)")
        }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        print("Got new auth status \(status.rawValue)")
        setUpLocationMonitoring()
    }
    
    func convertCoordinateToString(coordinate: CLLocationCoordinate2D) -> String {
        print("Coordinate to String: \(coordinate.latitude),\(coordinate.longitude)")
        return "\(coordinate.latitude),\(coordinate.longitude)"
    }
    
    func setUpLocationMonitoring() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .AuthorizedAlways, .AuthorizedWhenInUse:
                print("have access to loc")
                    locationManager.requestLocation()
            case .Denied, .Restricted:
                print("Location services disabled/restricted")
            case .NotDetermined:
                if (locationManager.respondsToSelector("requestWhenInUseAuthorization")) {
                    print("requesting loc auth")
                    locationManager.requestWhenInUseAuthorization()
                }
            }
        } else {
            print("Turn on location services in Settings!")
        }
    
    }

}


