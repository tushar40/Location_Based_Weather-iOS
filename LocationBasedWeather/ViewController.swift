//
//  ViewController.swift
//  LocationBasedWeather
//
//  Created by Tushar Gusain on 04/02/20.
//  Copyright © 2020 Hot Cocoa Software. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import MapKit.MKPlacemark

class ViewController: UIViewController {
    
    //MARK:- Property Variables
    private var mapView: GMSMapView!
    private var resultsViewController: GMSAutocompleteResultsViewController?
    private var searchController: UISearchController?
    private var resultView: UITextView?
    private let locationService = LocationService.shared
    private let zoomLevel = Constants.zoomLevel
    private var addressLabel: UILabel?
    private let segueIdentifier = "LocationWeatherSegue"
    private let locationSearchTableIdentifier = "LocationSearchTableViewController"
    private var marker: GMSMarker? = nil
    private var currentPlacemark: MKPlacemark? = nil
    private var currentLocation = Constants.PointOfInterest.hotCocoa
    
    //MARK:- ViewController Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        notificationCenter.addObserver(self, selector: #selector(gotCurrentLocation(_:)), name: .currentLocationNotification, object: locationService.self)
        locationService.startService()
        loadMap()
        setUpSearchBarControllers()
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
    
    private func setUpSearchBarControllers() {
        
        let locationSearchTable = storyboard?.instantiateViewController(withIdentifier: locationSearchTableIdentifier) as! LocationSearchTableViewController
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self
        
        searchController = UISearchController(searchResultsController: locationSearchTable)
        searchController?.searchResultsUpdater = locationSearchTable
        navigationItem.titleView = searchController!.searchBar
        searchController?.searchBar.sizeToFit()
        searchController?.searchBar.placeholder = "Search For Places"
        definesPresentationContext = true
        
        searchController?.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
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
        
        moveCameraToLocation(location: currentLocation)
    }
    
    private func moveCameraToLocation(location: CLLocation) {
        mapView.camera = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: zoomLevel)
        mapView.animate(to: mapView.camera)
    }
    
    private func addAddressLabel() {
        addressLabel = UILabel(frame: CGRect(origin: CGPoint(x: 0, y: mapView.bounds.maxY - 100), size: CGSize(width: mapView.bounds.width, height: 100)))
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
    
    //MARK:- Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifier, let destination = segue.destination as? WeatherViewController {
            destination.placemark = currentPlacemark
        }
    }
}

//MARK:- GMSMapView Delegate Methods

extension ViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        locationService.reverseGeoCodeCoordinates(currentLocation.coordinate) { [weak self] addressString in
            self?.addressLabel?.text = addressString
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        if currentPlacemark != nil {
            performSegue(withIdentifier: segueIdentifier, sender: self)
        }
    }
}

//MARK :- HandleMapSearch Delegate Methdods

extension ViewController: HandleMapSearchDelegate {
    func dropPinZoomIn(placeMark: MKPlacemark) {
        marker?.map = nil
        
        currentPlacemark = placeMark
        let position = placeMark.coordinate
        marker = GMSMarker(position: position)
        marker?.title = placeMark.title
        marker?.map = mapView
        
        let camera = GMSCameraPosition.camera(withTarget: placeMark.coordinate, zoom: zoomLevel)
        mapView.camera = camera
    }
}
