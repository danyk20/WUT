//
//  BackgroundMap.swift
//  wakeUpThere
//
//  Created by Daniel Košč on 10/03/2023.
//

import Foundation
import SwiftUI
import CoreLocation
import MapKit

struct BackgroundMap: UIViewRepresentable {
    @Binding var zoom: Int
    @Binding public var locations: [Location]

    var locationManager = CLLocationManager()
    func setupManager() {
      locationManager.desiredAccuracy = kCLLocationAccuracyBest
      locationManager.requestWhenInUseAuthorization()
      locationManager.requestAlwaysAuthorization()
    }

    func makeUIView(context: Context) -> MKMapView {
        setupManager()
        let mapView = MKMapView(frame: UIScreen.main.bounds)
        mapView.showsUserLocation = true
        let region = MKCoordinateRegion(
            center: locationManager.location!.coordinate,
            latitudinalMeters: CLLocationDistance(exactly: zoom)!,
            longitudinalMeters: CLLocationDistance(exactly: zoom)!)
        mapView.setRegion(mapView.regionThatFits(region), animated: true)
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        // update zoom
        uiView.setRegion(MKCoordinateRegion(
            center: locationManager.location!.coordinate,
            latitudinalMeters: CLLocationDistance(exactly: zoom) ?? 65536.0,
            longitudinalMeters: CLLocationDistance(exactly: zoom) ?? 65536.0), animated: true)
        // update pin on the Map
        let annotation = MKPointAnnotation()
        if locations.count > 0 {
            if !uiView.annotations.isEmpty {
                uiView.removeAnnotations(uiView.annotations)
            }
            let centerCoordinate = CLLocationCoordinate2D(latitude: locations.first!.latitude, longitude: locations.first!.longitude)
            annotation.coordinate = centerCoordinate
            annotation.title = locations.first?.name
            uiView.addAnnotation(annotation)
        }
    }

    public func zoomOut() {
        if zoom < 16777216 {
            zoom *= 2
        }
    }

    public func zoomIn() {
        if zoom > 10 {
            zoom /= 2
        }
    }

}
