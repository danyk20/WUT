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
    @State private var suggestions: [Datum] = []
    var body: some View {
        let binding = Binding<String>(get: {
                    self.destination
                }, set: {
                    self.destination = $0
                    mapView.setLocation(address: destination){ places in
                        suggestions = places
                    }
                })
        VStack{
            TextField("Enter your \(vehicle.rawValue) final destination!", text: binding)
                .font(.title2)
                .multilineTextAlignment(.center)
            Button("Set selected destination", action: {
                // to do
            })
            ZStack{
                mapView
                    .ignoresSafeArea()
                if (!suggestions.isEmpty){
                        suggestionView(dataArray: $suggestions, mapView: mapView)
                }
            }
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
