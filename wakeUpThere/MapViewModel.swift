//
//  MapViewModel.swift
//  wakeUpThere
//
//  Created by Daniel Košč on 30/05/2022.
//

import MapKit
import SwiftUI

enum MapDetails {
    
    static let startingLocation = CLLocationCoordinate2D(latitude: 39.8, longitude: -92.8)
    static let defaultSpan = MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2)
}

/// Class to deal with location operation and map display settings.
final class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var region: MKCoordinateRegion = MKCoordinateRegion(center: MapDetails.startingLocation , span: MapDetails.defaultSpan)
    @Published var location : CLLocation? // last updated user location (not in use)
    private var travel: TravelModel? // global storage
    
    var locationManager: CLLocationManager?
    
    /// Check if the user has location service turned on with necessary permissions and set background tracking.
    func chcekIfLocationServicesIsEnable() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            if let locationManager = locationManager {
                locationManager.delegate = self
                locationManager.startUpdatingLocation()
                locationManager.allowsBackgroundLocationUpdates = true
            }
        }
        else {
            print("Show alert")
        }
    }
    
    /// Get the user's current location coordinates.
    /// - Returns: coordinates as CLLocationCoordinate2D if found otherwise nil
    public static func getCurrentLocation(locationManager: CLLocationManager? = CLLocationManager()) -> CLLocationCoordinate2D?{
        guard let locationManager = locationManager else {
            return nil
        }
        guard let currentLocation = locationManager.location else {
            return nil
        }
        return currentLocation.coordinate
    }
    
    /// Check given permission and centre map based on user position in case of correct permissions triggered by permission change.
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
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
            region = MKCoordinateRegion(center: locationManager.location!.coordinate, span: MapDetails.defaultSpan)
        case .authorizedWhenInUse:
            print("Wrong permition")
            locationManager.requestAlwaysAuthorization()
        @unknown default:
            break
        }
    }
    
    /// Adding global varibale to the class
    /// - Parameter travel: reference on global variable
    public func setTravelModel(travel: TravelModel){
        self.travel = travel
    }
    
    /// Change the zoom of the map and update user position.
    /// - Parameter cooeficient: coefficient of a change bigger than 1 will zoom out and opposite
    public func updateZoom(cooeficient: Double){
        if (self.region.span.longitudeDelta < 91 || cooeficient < 1){
            withAnimation {
                self.location = locationManager?.location
                self.region.span.latitudeDelta *= cooeficient
                self.region.span.longitudeDelta *= cooeficient
            }
        }
    }
    
    /// Always centre map on the user's current position.
    /// - Parameters:
    ///   - manager: location manager
    ///   - locations: array of user's locations
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.location = locations.first
        
        travel?.remainingDistance = MapAPI.instance.getRemainingDistance() - (travel?.perimeter ?? 0) * 1000
        if NotificationController.instance.setRemainingDistance(distance: MapAPI.instance.getRemainingDistance()){
            travel?.alertCode = -2
            travel?.throwAlert = true
        }
        // centre map to new user location
        if let newLocation = self.location {
            region.center = CLLocationCoordinate2D(latitude: newLocation.coordinate.latitude, longitude: newLocation.coordinate.longitude)
        }
    }
}
