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
    @ObservedObject private var mapModel = PositionLocator() // map settings

    @State public var zoom: Int = 65536
    @State public var locations: [Location] = []
    @State public var map: BackgroundMap?

    var body: some View {
        ZStack(alignment: .bottom) {
            map
            // update map to see new pin on the map
                .onChange(of: mapAPI.locations) { _ in
                    locations = mapAPI.locations
                    if !locations.isEmpty {
                        travel.destination = locations[0]
                    }
                }

            VStack { // zoom in/out buttons
                if let map = map {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            map.zoomIn()
                        }, label: {
                            Image(systemName: "plus.magnifyingglass")
                                .font(.title)
                        })
                        .padding()
                    }
                    HStack {
                        Spacer()
                        Button(action: {
                            map.zoomOut()
                        }, label: {
                            Image(systemName: "minus.magnifyingglass")
                                .font(.title)
                        })
                        .padding()
                    }
                }
            }
            .onAppear {
                mapModel.setTravelModel(travel: travel)
                map = BackgroundMap(zoom: $zoom, locations: $locations)
            }
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView().environmentObject(TravelModel())
    }
}
