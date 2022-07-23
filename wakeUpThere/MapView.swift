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
    @EnvironmentObject var travel: TravelModel
    @ObservedObject private var mapAPI = MapAPI.instance // API to get suggested places
    @ObservedObject private var mapModel = MapViewModel() // map settings
    @State private var map: Map<_DefaultAnnotatedMapContent<[Location]>>?
    @State private var destinationColor: Color = .blue // pin-mark color
    
    var body: some View {
        ZStack(alignment: .bottom){
            map
            // update map to see user location or zoom change
                .onChange(of: mapModel.location) { _ in
                    updateMap()
                }
            // update mapt ot see new pin on the map
                .onChange(of: mapAPI.locations) { _ in
                    updateMap()
                }
                .ignoresSafeArea()
                
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
            .onAppear{
                mapModel.setTravelModel(travel: travel)
                mapModel.chcekIfLocationServicesIsEnable()
                updateMap()
            }
        }
    }
    
    /// Reload map on the view with new updated parameters
    public func updateMap(){
        map = Map(coordinateRegion: $mapModel.region,
                   showsUserLocation: true,
                   annotationItems: mapAPI.locations){ location in
                   MapMarker(coordinate: location.getCoordinates2D(), tint: destinationColor)
        }
    }
    
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
