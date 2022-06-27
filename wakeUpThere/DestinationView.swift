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
    @State private var distance: Double = Double.infinity
    @State private var showAlert: Bool = false
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
                distance = mapView.getDistance()
                showAlert.toggle()
            })
            ZStack{
                mapView
                    .ignoresSafeArea()
                if (!suggestions.isEmpty){
                        suggestionView(dataArray: $suggestions, mapView: mapView)
                }
            }
            .alert(isPresented: $showAlert,content: {
                getAlert(distance: distance)
            })
        }
        .navigationBarTitle(Text(""), displayMode: .inline)
        .navigationBarItems(trailing: Image(systemName: vehicle.getIconName()))
    }
    
    private func getAlert(distance: Double) -> Alert{
        if distance == Double.infinity{
            return Alert(title: Text("Error ocurred try again later!"))
        }
        
        var formatedDistance = ""
        if distance > 10000{
            formatedDistance =  String(format: "%d", locale: Locale.current, Int(round(distance/1000))) +  " km"
        }
        else {
            formatedDistance =  String(format: "%d", locale: Locale.current, Int(round(distance))) +  " m"
        }
        return Alert(title: Text("Remaining distance is: \(formatedDistance)"))
    }
}

struct DestinationView_Previews: PreviewProvider {
    @State static var a : Bool = true
    static var previews: some View {
        DestinationView(vehicle: .Bus)
    }
}
