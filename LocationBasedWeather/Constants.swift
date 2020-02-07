//
//  Constants.swift
//  LocationBasedWeather
//
//  Created by Tushar Gusain on 04/02/20.
//  Copyright © 2020 Hot Cocoa Software. All rights reserved.
//

import Foundation
import GoogleMaps

struct Constants {
    static let PlacesApiKey = "AIzaSyA7seHCuO9E9nfLeI_BPiLItPTOLrZNbvc"
    static let WeatherApiKey = "701b5db787e5ab9a0b34814d23af044f"
    static let distanceFilter = 1.0
    static let zoomLevel: Float = 18.0
    
    //MARK:- Points of Interest struct
    
    struct PointOfInterest {
        static let hotCocoa = CLLocation(latitude: 28.537750, longitude: 77.210376)
        static let hauzKhasMetro = CLLocation(latitude: 28.543735, longitude: 77.206455)
        static let dilshadGarden = CLLocation(latitude: 28.687507, longitude: 77.322567)
        static let dgMetro = CLLocation(latitude: 28.676190, longitude: 77.321492)
        
        static let pointsOfInterestDictionary = ["Hot Cocoa Software": hotCocoa, "Hauz Khas Metro Station": hauzKhasMetro, "Home Dilshad Garden": dilshadGarden, "Dilshad Garden Metro Station": dgMetro]
        
        static func getAllPointsOfInterest() -> [CLLocation] {
            let allPoi = [hotCocoa, hauzKhasMetro, dilshadGarden, dgMetro]
            return allPoi
        }
    }
    
    //MARK:- Notification UserInfo Keys
    struct NotificationUserInfoKey {
        static let locationKey = "location"
    }
}
