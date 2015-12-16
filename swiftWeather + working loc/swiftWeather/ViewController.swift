//
//  ViewController.swift
//  swiftWeather
//
//  Created by Cameron Westbury on 11/3/15.
//  Copyright © 2015 Cameron Westbury. All rights reserved.
//

import UIKit
import CoreLocation


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate {
    
    //MARK: - Properties
    
    var viewControllerLocationManager: CLLocationManager = CLLocationManager()
    
    var networkManger = NetworkManager.sharedInstance
    var dataManager = DataManager.sharedInstance
    var locManger = LocationManager.sharedInstance
    let revCoordManager = CoordManager.sharedInstance
    
    
    @IBOutlet var locationSearchBar :UISearchBar!
    @IBOutlet var weatherTableView : UITableView!
    
    
    var cityName = "" as String
    
    
    
    
    
    //MARK: - Tableview Methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  dataManager.weatherArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : WeatherCustomTableViewCell = tableView.dequeueReusableCellWithIdentifier("cell") as! WeatherCustomTableViewCell
        let weatherInfo = dataManager.weatherArray[indexPath.row]
        let tempFloat = Float(weatherInfo.temperature! as String)!
        cell.temperatureLabel.text = String(format: tempFloat == floor(tempFloat) ? "%.0f" : "%.0f", tempFloat) + " ℉"
        
        
        cell.locationLabel.text = cityName
        cell.windSpeedLabel.text = "Wind Speed: " + String(weatherInfo.windSpeed.characters.dropLast(1)) + " Mph"
        cell.percipProbabilityLabel.text = "Rain Chance: " + weatherInfo.precipProbability + " %"
        
        
        
        switch weatherInfo.icon {
        case "clear-day":
            cell.weatherImage.image = UIImage(named: "sunny")
        case "clear-night":
            cell.weatherImage.image = UIImage(named: "night")
            
        case "partly-cloudy-night":
            cell.weatherImage.image = UIImage(named: "partlyCloudy")
            
        case "partly-cloudy-day":
            cell.weatherImage.image = UIImage(named: "partlyCloudy")
            
            
        case "cloudy", "fog":
            cell.weatherImage.image = UIImage(named: "overcast")
            
        case "wind":
            cell.weatherImage.image = UIImage(named: "windy")
            
        case "rain", "sleet":
            cell.weatherImage.image = UIImage(named: "rain")
            
        case "snow":
            cell.weatherImage.image = UIImage(named: "snow")
        default:
            cell.weatherImage.image = nil
        }
        
        return cell
    }
    
    
    //MARK: - Interactivity
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if networkManger.serverAvailable {
            if locationSearchBar.text?.characters.count > 0  {
                dataManager.getWeatherData(locationSearchBar.text!)
                cityName = locationSearchBar.text!
                [locationSearchBar.resignFirstResponder()]
                
                
            }
        } else {
            print("Server: Not availiable")
        }
    }
    
    
    //MARK: - Listener Methods
    
    func newDataRecieved(){
        print("new Data Recieved")
        
        if locationSearchBar.text != nil {
            cityName = revCoordManager.ReverseGeoCoderSearchedCityName
            
        } else {
            
            cityName = dataManager.SearchCity
        }
        
        //print("cityName = \(dataManager.SearchCity)")
        
        
        weatherTableView.reloadData()
        weatherTableView.hidden = false
        
    }
    
    func newLocRecieved(){
        locManger.locationManager.stopUpdatingLocation()
        print("new Loc Recieved")
        
        print("city being passed: \(locManger.cityName)")
        cityName =   locManger.cityName
        weatherTableView.reloadData()
        dataManager.getWeatherData(locManger.convertCoordinateToString(locManger.userLocationCoordinates))
        
        
    }
    
    
    
    
    //MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherTableView.hidden = true
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "newDataRecieved", name: "recievedDataFromServer", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "newLocRecieved", name: "recievedLocationFromUser", object: nil)
        locManger.setUpLocationMonitoring()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}

