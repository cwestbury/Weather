//
//  DataManager.swift
//  swiftWeather
//
//  Created by Cameron Westbury on 11/3/15.
//  Copyright © 2015 Cameron Westbury. All rights reserved.
//

import UIKit
import CoreLocation

class DataManager: NSObject {
    
    
    //MARK: - Properties
    static let sharedInstance = DataManager() //fill the array here
    
    let revCoordManager = CoordManager.sharedInstance
    var SearchCity = ""
    
    var baseURLstring = "api.forecast.io"
    var darkSkyKey = "6a0abebbe2c365efb6c5e8460b8ecd58"
    var tempCoords = "37.8267,-122.423"
    
    
    var weatherArray = [currentWeather]() //change array type later?
    
    func JSONandTheGoldenParse (data: NSData) {
        do {
            let jsonResult = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)
            let tempDic = jsonResult.objectForKey("currently") as! NSDictionary
            self.weatherArray.removeAll()
            let weatherStat = currentWeather()
            weatherStat.precipProbability = String((tempDic.objectForKey("precipProbability") as! Double)*100)
            weatherStat.summary = tempDic.objectForKey("summary") as! String
            weatherStat.icon = tempDic.objectForKey("icon") as! String
            weatherStat.temperature = String(tempDic.objectForKey("temperature") as! Double)
            weatherStat.apparentTemperature = String(tempDic.objectForKey("apparentTemperature") as! Double)
            weatherStat.windSpeed = String(tempDic.objectForKey("windSpeed") as! Double)
            self.weatherArray.append(weatherStat)
            print("The Current Temp is: \(weatherStat.temperature)")
        } catch {
            print("Json parse failed")
        }
        dispatch_async(dispatch_get_main_queue()){
            NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "recievedDataFromServer", object: nil))
        }
        
        
    }
    
    
    
    func getWeatherData(searchString: String) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        defer {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(searchString) { (placemarks, error) -> Void in
            if let firstPlacemark = placemarks?.first {
                let coords = firstPlacemark.location!.coordinate
                let coordString = "\(coords.latitude),\(coords.longitude)"
                print(coordString)
                self.revCoordManager.reverseGeocodeCoords(coords.latitude, long: coords.longitude)
                self.SearchCity = self.revCoordManager.ReverseGeoCoderSearchedCityName
                print("Data Manager: City \(self.SearchCity)")
                
                
                let url = NSURL(string: "https://\(self.baseURLstring)/forecast/\(self.darkSkyKey)/\(coordString)")
                print("Search URL:\(url!)")
                let urlRequest = NSURLRequest(URL: url!, cachePolicy: .ReloadIgnoringLocalCacheData, timeoutInterval: 30.0)
                let urlSession = NSURLSession.sharedSession()
                let task = urlSession.dataTaskWithRequest(urlRequest) { (data, response, error) -> Void in
                    if data != nil {
                        print("Got Data")
                        self.JSONandTheGoldenParse(data!)
                        dispatch_async(dispatch_get_main_queue()) {
                            NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "receivedDataFromServer", object: nil))
                        }
                    } else {
                        print("No Data")
                    }
                }
                task.resume()
            }
        }
    }
    
    
}













