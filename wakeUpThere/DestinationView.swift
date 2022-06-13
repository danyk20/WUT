//
//  DestinationView.swift
//  wakeUpThere
//
//  Created by Daniel Košč on 09/06/2022.
//

import SwiftUI
import MapKit

struct DestinationView: View {
    let vehicle : TransportType
    @State private var destination : String = ""
    @State private var mapView = MapView()
    var body: some View {
        VStack{
            TextField("Enter your \(vehicle.rawValue) final destination!", text: $destination)
                .font(.title2)
                .multilineTextAlignment(.center)
            Button("Find destination", action: {
                mapView.setLocation(address: destination, delta: 100000)
            })
            mapView
                .ignoresSafeArea()
        }
        .navigationBarTitle(Text(""), displayMode: .inline)
        .navigationBarItems(trailing: Image(systemName: vehicle.getIconName()))
    }
}

struct DestinationView_Previews: PreviewProvider {
    @State static var a : Bool = true
    static var previews: some View {
        DestinationView(vehicle: .Bus)
    }
}
