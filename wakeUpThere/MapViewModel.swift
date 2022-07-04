//
//  MapViewModel.swift
//  wakeUpThere
//
//  Created by Daniel Košč on 30/05/2022.
//

import MapKit

enum MapDetails {
    
    static let startingLocation = CLLocationCoordinate2D(latitude: 39.8, longitude: -92.8)
    static let defaultSpan = MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2)
}

final class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var region = MKCoordinateRegion(center: MapDetails.startingLocation , span: MapDetails.defaultSpan)
    @Published var location : CLLocation?
    
    var locationManager: CLLocationManager?
    
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
    
    private func chceckLocationAuthorization() {
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
    
    func getCurrentLocation() -> CLLocationCoordinate2D?{
        guard let locationManager = locationManager else {
            return nil
        }
        return locationManager.location!.coordinate
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        chceckLocationAuthorization()
    }
    
    func updateZoom(cooeficient: Double){
        if (self.region.span.longitudeDelta < 130 || cooeficient < 1)
        {
                self.region.span.latitudeDelta *= cooeficient
                self.region.span.longitudeDelta *= cooeficient
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first
        // centre map to new user location
        if let newLocation = location {
            region.center = CLLocationCoordinate2D(latitude: newLocation.coordinate.latitude, longitude: newLocation.coordinate.longitude)
        }
    }
}
