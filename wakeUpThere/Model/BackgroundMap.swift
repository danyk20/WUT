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
    var zoom: Int = 65536
    @State var locations: [Location] = []
    @EnvironmentObject var travel: TravelModel
    @ObservedObject var mapAPI: MapAPI = MapAPI.instance
    var locationManager = CLLocationManager()
    
    private func setupManager() {
      locationManager.desiredAccuracy = kCLLocationAccuracyBest
      locationManager.requestWhenInUseAuthorization()
      locationManager.requestAlwaysAuthorization()
    }

    func makeUIView(context: Context) -> MKMapView {
        print("Initializing BackgroundMap") // when it is called and why?
        setupManager()
        let mapView = MKMapView(frame: UIScreen.main.bounds)
        mapView.showsUserLocation = true
        mapView.setRegion(mapView.regionThatFits(getCurrentRegion()), animated: true)
        mapView.delegate = context.coordinator
        let longPressed = UILongPressGestureRecognizer(target: context.coordinator,
                                                           action: #selector(context.coordinator.addPinBasedOnGesture(_:)))
        mapView.addGestureRecognizer(longPressed)
        PositionLocator().setTravelModel(travel: travel)
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        // update zoom
        uiView.setRegion(getCurrentRegion(), animated: true)
        // update pin on the Map
        let annotation = MKPointAnnotation()
        if locations.count > 0, let target = locations.first {
            if !uiView.annotations.isEmpty {
                uiView.removeAnnotations(uiView.annotations)
            }
            let centerCoordinate = CLLocationCoordinate2D(latitude: target.latitude, longitude: target.longitude)
            annotation.coordinate = centerCoordinate
            annotation.title = target.name
            annotation.subtitle = target.region
            uiView.addAnnotation(annotation)
        }
    }

    public mutating func zoomOut() {
        if zoom < 16777216 {
            zoom *= 2
        }
    }

    public mutating func zoomIn() {
        if zoom > 10 {
            zoom /= 2
        }
    }

    private func getCurrentRegion() -> MKCoordinateRegion {
        if let currentLocation = locationManager.location {
            return MKCoordinateRegion(
                center: currentLocation.coordinate,
                latitudinalMeters: CLLocationDistance(exactly: zoom) ?? 65536.0,
                longitudinalMeters: CLLocationDistance(exactly: zoom) ?? 65536.0)
        }
        print("Current location is unknown")
        return MKCoordinateRegion()
    }

    internal func makeCoordinator() -> MapViewCoordinator {
        MapViewCoordinator(self, travel: travel)
    }

}
