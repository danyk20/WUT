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
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
