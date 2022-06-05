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
    @StateObject private var mapModel = MapViewModel()
    var body: some View {
        ZStack(alignment: .bottom){
            Map(coordinateRegion: $mapModel.region, showsUserLocation: true)
                .ignoresSafeArea()
                .onAppear{
                    mapModel.chcekIfLocationServicesIsEnable()
                }
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
