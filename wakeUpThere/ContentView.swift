//
//  ContentView.swift
//  wakeUpThere
//
//  Created by Daniel Košč on 22/05/2022.
//

import SwiftUI
import MapKit

struct ContentView: View {
    
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 40, longitude: 120), span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5))
    
    var body: some View {
        Text("Hello, world!")
            .padding()
            
        ZStack{
            Map(coordinateRegion: $region, showsUserLocation: true)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
