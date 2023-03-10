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
    @State public var region: MKCoordinateRegion = MKCoordinateRegion(center: MapDetails.startingLocation, span: MapDetails.defaultSpan)

    var body: some View {
        ZStack(alignment: .bottom) {
            map
            // initial update map to see user location or zoom change
                .onReceive(mapModel.$region) { _ in
                    updateMap()
                }
            // update map to see new pin on the map
                .onChange(of: mapAPI.locations) { _ in
                    updateMap()
                }
                .ignoresSafeArea()

            VStack { // zoom in/out buttons
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {mapModel.updateZoom(cooeficient: 0.5)
                    }, label: {
                        Image(systemName: "plus.magnifyingglass")
                            .font(.title)
                    })
                    .padding()
                }
                HStack {
                    Spacer()
                    Button(action: {mapModel.updateZoom(cooeficient: 2)
                    }, label: {
                        Image(systemName: "minus.magnifyingglass")
                            .font(.title)
                    })
                    .padding()
                }
            }
            .onAppear {
                mapModel.setTravelModel(travel: travel)
                mapModel.setRegionCenteredOnUserLocation()
            }
        }
    }

    /// Reload map on the view with new updated parameters
    public func updateMap() {
        self.region = mapModel.region
        map = Map(coordinateRegion: $region,
                   showsUserLocation: true,
                   annotationItems: []) { location in
                   MapMarker(coordinate: location.getCoordinates2D(), tint: destinationColor)
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView().environmentObject(TravelModel())
    }
}
