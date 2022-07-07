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
    @ObservedObject private var mapAPI = MapAPI() // API to get suggested places
    @ObservedObject private var mapModel = MapViewModel() // map settings
    @State private var destinationColor: Color = .blue // pin-mark color
    
    var body: some View {
        ZStack(alignment: .bottom){
            Map(coordinateRegion: $mapModel.region,
                showsUserLocation: true,
                annotationItems: mapAPI.locations){ location in
                MapMarker(coordinate: location.getCoordinates2D(), tint: destinationColor) // show pin-mark on the map after the user chose the destination
            }
                // always when the position changed recalculate remaining distance
                .onChange(of: self.mapModel.location, perform: { _ in
                    checkRemainingDistance()
                })
                .ignoresSafeArea()
                .onAppear{
                    mapModel.chcekIfLocationServicesIsEnable()
                }
            VStack(){ // zoom in/out buttons
                Spacer()
                HStack{
                    Spacer()
                    Button(action: {
                        mapModel.updateZoom(cooeficient: 0.5)
                    }, label: {
                        Image(systemName: "plus.magnifyingglass")
                            .font(.title)
                    })
                    .padding()
                }
                HStack{
                    Spacer()
                    Button(action: {
                        mapModel.updateZoom(cooeficient: 2)
                    }, label: {
                        Image(systemName: "minus.magnifyingglass")
                            .font(.title)
                        
                    })
                    .padding()
                }
            }
        }
    }
    
    /// Get suggestions of all possible places based on given address.
    /// - Parameters:
    ///   - address: string value representing any place
    ///   - completion: return value than contain an array of suggestions
    public func getSuggestions(address: String, completion: @escaping (([Location])->Void)){
        mapAPI.getPossiblePlaces(address: address){ places in
            completion(places)
        }
    }
    
    /// Put a pin-mark marker on the selected destination on the map.
    /// - Parameter selectedLocation: pin-marker location
    public func selectLocation(selectedLocation: Location){
        mapAPI.setDestination(selectedLocation: selectedLocation)
    }
    
    /// Get air distance between the selected destination and current location.
    /// - Returns: air distance in meters
    public func getDistance() -> Double{
        guard let currentLocation = mapModel.getCurrentLocation() else
        {
            return Double.infinity
        }
        return self.mapAPI.getRemainingDistance(startLocation: currentLocation)
    }
    
    /// Call notification handler to check if the user approached close enough to trigger an alert.
    private func checkRemainingDistance(){
        NotificationController.instance.setRemainingDistance(distance: getDistance())
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
