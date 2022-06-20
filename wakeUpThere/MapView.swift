//
//  MapView.swift
//  wakeUpThere
//
//  Created by Daniel Košč on 04/06/2022.
//

import SwiftUI
import MapKit
import CoreLocationUI

struct MapView: View {
    @ObservedObject private var mapAPI = MapAPI()
    @StateObject private var mapModel = MapViewModel()
    var body: some View {
        ZStack(alignment: .bottom){
            Map(coordinateRegion: $mapModel.region, showsUserLocation: true, annotationItems: mapAPI.locations){ location in
                MapMarker(coordinate: location.coordinate, tint: .blue)
            }
                .ignoresSafeArea()
                .onAppear{
                    mapModel.chcekIfLocationServicesIsEnable()
                }
        }
    }
    
    public func setLocation(address: String, delta: Double, completion: @escaping (([Datum])->Void)){
        mapAPI.getPossiblePlaces(address: address, delta: delta){ places in
            completion(places)
        }
    }
    
    public func selectPlace(selectedLocation: Datum, delta: Double){
        mapAPI.getLocation(selectedLocation: selectedLocation, delta: delta)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
