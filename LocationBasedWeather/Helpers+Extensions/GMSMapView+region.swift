//
//  GMSMapView+region.swift
//  LocationBasedWeather
//
//  Created by Tushar Gusain on 07/02/20.
//  Copyright © 2020 Hot Cocoa Software. All rights reserved.
//

import Foundation
import GoogleMaps
import MapKit

extension GMSMapView {
    var region : MKCoordinateRegion {
        get {
            ////let position = self.camera
            let visibleRegion = self.projection.visibleRegion()
            let bounds = GMSCoordinateBounds(region: visibleRegion)
            let latitudeDelta = bounds.northEast.latitude - bounds.southWest.latitude
            let longitudeDelta = bounds.northEast.longitude - bounds.southWest.longitude
            let center = CLLocationCoordinate2D(
                latitude: (bounds.southWest.latitude + bounds.northEast.latitude) / 2,
                longitude: (bounds.southWest.longitude + bounds.northEast.longitude) / 2)
            let span = MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
            return MKCoordinateRegion(center: center, span: span)
        }
//        set {
//            let northEast = CLLocationCoordinate2D(latitude: newValue.center.latitude - newValue.span.latitudeDelta/2, longitude: newValue.center.longitude - newValue.span.longitudeDelta/2)
//            let southWest = CLLocationCoordinate2D(latitude: newValue.center.latitude + newValue.span.latitudeDelta/2, longitude: newValue.center.longitude + newValue.span.longitudeDelta/2)
//            let bounds = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
//            let update = GMSCameraUpdate.fit(bounds, withPadding: 0)
//            self.moveCamera(update)
//        }
    }
}
