//
//  DestinationView.swift
//  wakeUpThere
//
//  Created by Daniel Košč on 09/06/2022.
//

import SwiftUI
import MapKit

struct DestinationView: View {
    @State private var mapView = MapView()
    @State private var distanceView : DistanceSelectionView?
    @State private var suggestions: [Datum] = []
    @State private var destination : String = ""
    //@State private var distance: Double = Double.infinity
    @State private var selectedDestination: Bool = false
    @State private var selectedPerimeter: Bool = false
    @State private var perimeter: Double = 2.5
    let vehicle : TransportType
    
    var body: some View {
        let binding = Binding<String>(get: {
                    self.destination
                }, set: {
                    selectedDestination = false
                    self.destination = $0
                    mapView.setLocation(address: destination){ places in
                        suggestions = places
                    }
                })
        VStack{
            TextField("Enter your \(vehicle.rawValue) final destination!", text: binding)
                .font(.title2)
                .multilineTextAlignment(.center)
            if !selectedDestination {
                Button("Set selected destination", action: {
                    selectedDestination = true
                    selectedPerimeter = false
                })
            }
            ZStack{
                mapView
                    .ignoresSafeArea()
                if (!suggestions.isEmpty && !selectedDestination){
                        suggestionView(dataArray: $suggestions, mapView: mapView)
                }
                if (selectedDestination && !selectedPerimeter) {
                    if let distanceView = distanceView {
                        distanceView
                    }
                }
            }
            .alert(isPresented: $selectedPerimeter,
                   content: {
                getAlert(trigerDistance: perimeter)
            })
        }
        .onAppear(perform: {
            distanceView = DistanceSelectionView(
                perimeter: $perimeter,
                selectedPerimeter: $selectedPerimeter)})
        .navigationBarTitle(Text(""), displayMode: .inline)
        .navigationBarItems(trailing: Image(systemName: vehicle.getIconName()))
    }
    
    private func getAlert(trigerDistance: Double) -> Alert{
        
        //temporal
        let distance = mapView.getDistance()
        if (distance < perimeter * 1000){
            SoundManager.instance.playSound()
        }
        
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
        return Alert(title: Text("Remaining distance is: \(formatedDistance)"),
                     message: Text("You will be notified " + String(format: "%.1f", trigerDistance) + " km before your destination!"))
    }
}

struct DestinationView_Previews: PreviewProvider {
    @State static var a : Bool = true
    static var previews: some View {
        DestinationView(vehicle: .Bus)
    }
}
