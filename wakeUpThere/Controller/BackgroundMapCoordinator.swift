//
//  BackgroundMapCoordinator.swift
//  wakeUpThere
//
//  Created by Daniel Košč on 31/03/2023.
//

import Foundation
import MapKit

class MapViewCoordinator: NSObject, MKMapViewDelegate {
    private var mapViewController: BackgroundMap
    var travel: TravelModel

    init(_ control: BackgroundMap, travel: TravelModel) {
        self.mapViewController = control
        self.travel = travel
    }

    @objc func addPinBasedOnGesture(_ gestureRecognizer: UIGestureRecognizer) {
        let touchPoint = gestureRecognizer.location(in: gestureRecognizer.view)
        let newCoordinates = (gestureRecognizer.view as? MKMapView)?.convert(touchPoint, toCoordinateFrom: gestureRecognizer.view)
        if let cordinates = newCoordinates {
            MapAPI.instance.setDestination(selectedLocation: Location(location2D: cordinates))
            MapAPI.instance.getPositionFromCoordinates(coordinates: cordinates) { locations in
                if !locations.isEmpty {
                    // save location for target computation
                    MapAPI.instance.setDestination(selectedLocation: locations[0])
                    // show pin on the map
                    self.mapViewController.locations = [locations[0]]
                }
            }
        }
        travel.state = .approachSetting
    }

}
