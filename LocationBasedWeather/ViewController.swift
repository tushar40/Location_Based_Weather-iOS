//
//  ViewController.swift
//  LocationBasedWeather
//
//  Created by Tushar Gusain on 04/02/20.
//  Copyright © 2020 Hot Cocoa Software. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController {
    
    //MARK:- Property Variables
    private var mapView: GMSMapView!
    private let locationService = LocationService.shared
    private let zoomLevel = Constants.zoomLevel
    private var addressLabel: UILabel?
    private var currentLocation = Constants.PointOfInterest.hotCocoa {
        didSet {
            moveCameraToLocation(location: currentLocation)
        }
    }
    
    //MARK:- ViewController Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        notificationCenter.addObserver(self, selector: #selector(gotCurrentLocation(_:)), name: .currentLocationNotification, object: locationService.self)
        locationService.startService()
        loadMap()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        locationService.stopService()
        super.viewWillDisappear(animated)
    }

    //MARK:- Custom Methods
    
    @objc func gotCurrentLocation(_ notification: Notification) {
        if let info = notification.userInfo, let location = info[Constants.NotificationUserInfoKey.locationKey] as? CLLocation {
            currentLocation = location
        }
    }
    
    private func loadMap() {
        let camera = GMSCameraPosition.camera(withTarget: currentLocation.coordinate, zoom: zoomLevel)
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        mapView.settings.compassButton = true
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.delegate = self
        
        view.addSubview(mapView)
        addAddressLabel()
    }
    
    private func moveCameraToLocation(location: CLLocation) {
        mapView.camera = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: zoomLevel)
        mapView.animate(to: mapView.camera)
    }
    
    private func addAddressLabel() {
        addressLabel = UILabel(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: mapView.bounds.width, height: 100)))
        addressLabel?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addressLabel?.lineBreakMode = .byWordWrapping
        addressLabel?.textAlignment = .center
        addressLabel?.textColor = .blue
        addressLabel?.font = addressLabel?.font.withSize(18)
        addressLabel?.numberOfLines = 5
        addressLabel?.text = "ADDRESS"
        mapView.addSubview(addressLabel!)
        
        ////let margins = mapView.layoutMarginsGuide
        ////addressLabel?.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 0).isActive = true
        ////addressLabel?.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 0).isActive = true
        ////addressLabel?.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: 0).isActive = true
    }
}

//MARK:- GMSMapView Delegate Methods

extension ViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        locationService.reverseGeoCodeCoordinates(position.target) { [weak self] addressString in
            self?.addressLabel?.text = addressString
        }
    }
}
