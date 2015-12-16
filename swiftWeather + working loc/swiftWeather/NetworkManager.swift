//
//  NetworkManager.swift
//  swiftWeather
//
//  Created by Cameron Westbury on 11/3/15.
//  Copyright © 2015 Cameron Westbury. All rights reserved.
//

import UIKit

class NetworkManager: NSObject {
    static let sharedInstance = NetworkManager()
    
    private var serverReach: Reachability?
    var serverAvailable = false
    
    func reachabilityChanged(note: NSNotification) {
        let reach = note.object as! Reachability
        serverAvailable = !(reach.currentReachabilityStatus().rawValue == NotReachable.rawValue)
        if serverAvailable {
            print("Changed: Sever Available")
        } else {
            print("Changed: Not Availiable")
        }
    }
    
    override init() {
        super.init()
        print("Starting Network Manager")
        let dataManager = DataManager.sharedInstance
        print("Network Manager\(dataManager.baseURLstring)")
        serverReach = Reachability(hostName: dataManager.baseURLstring)
        
        serverReach?.startNotifier()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reachabilityChanged:", name: kReachabilityChangedNotification, object: nil)
    }
}

