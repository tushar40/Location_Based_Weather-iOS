//
//  LocationSearchTableViewController.swift
//  LocationBasedWeather
//
//  Created by Tushar Gusain on 07/02/20.
//  Copyright © 2020 Hot Cocoa Software. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps.GMSMapView

protocol HandleMapSearchDelegate {
    func dropPinZoomIn(placeMark: MKPlacemark)
}

class LocationSearchTableViewController: UITableViewController {

    //MARK:- Property variables
    
    private let reuseIdentifier = "LocationSearchCell"
    var handleMapSearchDelegate: HandleMapSearchDelegate?
    var mapItems: [MKMapItem] = []
    var mapView: GMSMapView? = nil
    
    //MARK:- ViewController Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mapItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
         
        let selectedItem = mapItems[indexPath.row].placemark
        cell.textLabel?.text = selectedItem.title
        cell.detailTextLabel?.text = parseAddress(selectedItem: selectedItem)

        return cell
    }
    
    //MARK:- UITableViewController Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = mapItems[indexPath.row].placemark
        handleMapSearchDelegate?.dropPinZoomIn(placeMark: selectedItem)
        dismiss(animated: true, completion: nil)
    }

    //MARK:- Custom Methods
    
    private func parseAddress(selectedItem: MKPlacemark) -> String {
        let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " ": ""
        let comma = ((selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.administrativeArea != nil)) ? ", " : ""
        let secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? " " : ""
        
        let addressLine = String(format: "%@%@%@%@%@%@%@",
                                 selectedItem.subThoroughfare ?? "",
                                 firstSpace,
                                 selectedItem.thoroughfare ?? "",
                                 comma,
                                 selectedItem.locality ?? "",
                                 secondSpace,
                                 selectedItem.administrativeArea ?? "")
        return addressLine
    }
}

//MARK:- UISearchResultsUpdating Methods

extension LocationSearchTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let mapview = mapView, let searchBarText = searchController.searchBar.text else { return }
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBarText
        request.region = mapview.region
        let search = MKLocalSearch(request: request)
        search.start { [weak self] response, error in
            guard let self = self else { return }
            if let response = response {
                self.mapItems = response.mapItems
            } else {
                self.mapItems = []
            }
            self.tableView.reloadData()
        }
    }
}
