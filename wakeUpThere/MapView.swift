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
    @ObservedObject private var mapAPI = MapAPI.instance // API to get suggested places
    @ObservedObject private var mapModel = MapViewModel() // map settings
    @State private var destinationColor: Color = .blue // pin-mark color
    
    private let approachedTitle: String = "You have approached to your destination!"
    private let approachedMessage: String = "Click Stop button to dismiss the notification."
    
    var body: some View {
        ZStack(alignment: .bottom){
            Map(coordinateRegion: $mapModel.region,
                showsUserLocation: true,
                annotationItems: mapAPI.locations){ location in
                MapMarker(coordinate: location.getCoordinates2D(), tint: destinationColor) // show pin-mark on the map after the user chose the destination
            }
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
        .alert(isPresented: $mapModel.enteredPerimeter, content: {
            return NotificationController.getAlert(title: approachedTitle, message: approachedMessage)
        })
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
