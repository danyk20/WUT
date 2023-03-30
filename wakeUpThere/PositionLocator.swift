//
//  PositionLocator.swift
//  wakeUpThere
//
//  Created by Daniel Košč on 30/05/2022.
//

import MapKit
import SwiftUI

/// Init map parameters
private enum MapDetails {

    static let startingLocation = CLLocationCoordinate2D(latitude: 39.8, longitude: -92.8)
    static let defaultSpan = MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2)
}

/// Class to deal with location operation and map display settings.
final class PositionLocator: NSObject, ObservableObject, CLLocationManagerDelegate {

    private static var region: MKCoordinateRegion = MKCoordinateRegion(center: MapDetails.startingLocation, span: MapDetails.defaultSpan)
    private static var location: CLLocation? // last updated user location (not in use)
    private var travel: TravelModel? // global storage
    private var locationManager: CLLocationManager?

    override init() {
        super.init()
        self.locationManager = CLLocationManager()
        if let locationManager = self.locationManager {
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
            locationManager.allowsBackgroundLocationUpdates = true
            PositionLocator.location = locationManager.location
        } else {
            print("Show alert")
        }
    }

    /// Adding global varibale to the class
    /// - Parameter travel: reference on global variable
    internal func setTravelModel(travel: TravelModel) {
        self.travel = travel
    }

    /// Get the user's current location coordinates.
    /// - Returns: coordinates as CLLocationCoordinate2D if found otherwise nil
    internal static func getCurrentLocation(locationManager: CLLocationManager? = CLLocationManager()) -> CLLocationCoordinate2D? {
        guard let locationManager = locationManager else {
            return nil
        }
        guard let currentLocation = locationManager.location else {
            return nil
        }
        return currentLocation.coordinate
    }

    /// Check given permission and centre map based on user position in case of correct permissions triggered by permission change.
    internal func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard let locationManager = locationManager else {
            return
        }

        switch locationManager.authorizationStatus {
            case .notDetermined:
                locationManager.requestAlwaysAuthorization()
            case .restricted:
                break
            case .denied:
                break
            case .authorizedAlways:
            if let currentLocation = locationManager.location {
                PositionLocator.region = MKCoordinateRegion(center: currentLocation.coordinate, span: MapDetails.defaultSpan)
            } else {
                print("No location avaible!")
            }
            case .authorizedWhenInUse:
                print("Wrong permition")
                locationManager.requestAlwaysAuthorization()
            @unknown default:
                break
        }
    }

    /// Always centre map on the user's current position.
    /// - Parameters:
    ///   - manager: location manager
    ///   - locations: array of user's locations
    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        PositionLocator.location = locations.first

        if let travel = self.travel {
            let remainingDistance = MapAPI.instance.getRemainingDistance()
            travel.remainingDistance = remainingDistance - travel.perimeter * 1000
            if travel.isPerimeterSelected && NotificationController.instance.setRemainingDistance(distance: remainingDistance) {
                travel.alertCode = -2
                travel.throwAlert = true
            }
        }

        PositionLocator.setRegionCenteredOnUserLocation()
    }

    /// Set region attribute based on user current location
    private static func setRegionCenteredOnUserLocation() {
        if let newLocation = PositionLocator.location {
            let latitude = newLocation.coordinate.latitude
            let longtitude = newLocation.coordinate.longitude
            PositionLocator.region.center = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
        }
    }
}
