//
//  LocationService.swift
//  Location_App
//
//  Created by Tushar Gusain on 30/01/20.
//  Copyright © 2020 Hot Cocoa Software. All rights reserved.
//

import Foundation
import GoogleMaps

class LocationService: NSObject {
    
    //MARK:- Property Variables
    
    private var locationManager: CLLocationManager?
    private let pointsOfInterestDictionary = Constants.PointOfInterest.pointsOfInterestDictionary
    private var locationState = [String: Bool]()
    private let distanceFilter = Constants.distanceFilter
    private let zoomLevel = Constants.zoomLevel
    private var geoCoder: GMSGeocoder!
    
    static let shared = LocationService()
    
    //MARK:- Initializers
    
    private override init() { }
    
    //MARK:- Member Methods
    
    func startService() {
        if locationManager == nil {
            locationManager = CLLocationManager()
            geoCoder = GMSGeocoder()
            locationManager?.delegate = self
        }
        locationManager?.allowsBackgroundLocationUpdates = true
        locationManager?.pausesLocationUpdatesAutomatically = true
        handleAuthorization(status: CLLocationManager.authorizationStatus())
    }
    
    func stopService() {
        locationManager?.stopUpdatingLocation()
        locationManager = nil
    }
    
    func reverseGeoCodeCoordinates(_ coordinates: CLLocationCoordinate2D, completion: @escaping (String) -> Void) {
        geoCoder.reverseGeocodeCoordinate(coordinates) { response, error in
            guard let address = response?.firstResult(), let lines = address.lines else { return }
            
            let addressText = lines.joined(separator: "\n")
            completion(addressText)
        }
    }
    
    private func handleAuthorization(status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            locationManager?.distanceFilter = distanceFilter
            locationManager?.startUpdatingLocation()
        } else {
            locationManager?.requestAlwaysAuthorization()
        }
    }
}

//MARK:- CLLocationManager Delegate Methods
extension LocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation = locations.first
        notificationCenter.post(name: .currentLocationNotification, object: self, userInfo: [Constants.NotificationUserInfoKey.locationKey : currentLocation])
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        handleAuthorization(status: status)
    }
}
