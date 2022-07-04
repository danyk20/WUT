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
    @ObservedObject private var mapModel = MapViewModel()
    @State private var destinationColor: Color = .blue
    
    var body: some View {
        ZStack(alignment: .bottom){
            Map(coordinateRegion: $mapModel.region,
                showsUserLocation: true,
                annotationItems: mapAPI.locations){ location in
                MapMarker(coordinate: location.coordinate, tint: destinationColor)
            }
                .onChange(of: self.mapModel.location, perform: { _ in
                    checkRemainingDistance()
                })
                .ignoresSafeArea()
                .onAppear{
                    mapModel.chcekIfLocationServicesIsEnable()
                }
            VStack(){
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
    
    public func setLocation(address: String, completion: @escaping (([Datum])->Void)){
        mapAPI.getPossiblePlaces(address: address, delta: 100){ places in
            completion(places)
        }
    }
    
    public func selectPlace(selectedLocation: Datum){
        mapAPI.getLocation(selectedLocation: selectedLocation, delta: 100)
    }
    
    public func getDistance() -> Double{
        guard let currentLocation = mapModel.getCurrentLocation() else
        {
            return Double.infinity
        }
        return self.mapAPI.getDistance(startLocation: currentLocation)
    }
    
    private func checkRemainingDistance(){
        NotificationController.instance.setRemainingDistance(distance: getDistance())
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
