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

    init(_ control: BackgroundMap) {
        self.mapViewController = control
    }

    @objc func addPinBasedOnGesture(_ gestureRecognizer: UIGestureRecognizer) {
        let touchPoint = gestureRecognizer.location(in: gestureRecognizer.view)
        let newCoordinates = (gestureRecognizer.view as? MKMapView)?.convert(touchPoint, toCoordinateFrom: gestureRecognizer.view)
        if let cordinates = newCoordinates {
            MapAPI.instance.setDestination(selectedLocation: Location(location2D: cordinates))
        }
    }

}
