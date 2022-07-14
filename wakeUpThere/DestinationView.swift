//
//  DestinationView.swift
//  wakeUpThere
//
//  Created by Daniel Košč on 09/06/2022.
//

import SwiftUI
import MapKit

struct DestinationView: View {
    @State private var mapView = MapView() // map in the background
    @State private var distanceView : DistanceSelectionView? // view to set input perimeter
    @State private var suggestions: [Location] = [] // suggested places for user
    @State private var destination : String = "" // user input of destination
    @State private var selectedDestination: Bool = false // user set destination
    @State private var selectedPerimeter: Bool = false // user set perimeter
    @State private var throwAlert: Bool = false // show some alert to the user
    @State private var perimeter: Double = 2.5 // in km
    @FocusState private var destinationInFocus: Bool
    var mapAPI: MapAPI = MapAPI.instance
    let vehicle: TransportType
    
    var body: some View {
        // watch the value of TextField, and if it has been changed, trigger these events
        let binding = Binding<String>(get: {
                    self.destination
                }, set: {
                    selectedDestination = false // show again destination list
                    self.destination = $0 // automatically select the first suggested place
                    mapAPI.getPossiblePlaces(address: destination) { places in
                        suggestions = places
                    }
//                    mapView.getSuggestions(address: destination){ places in
//                        suggestions = places // load all suggestions
//                    }
                })
        VStack{ // START: View
            TextField("Enter your \(vehicle.rawValue) final destination!", text: binding)
                .focused($destinationInFocus)
                .font(.title2)
                .multilineTextAlignment(.center)
            // show "set destination" button, until it is clicked
            if !selectedDestination {
                Button("Set selected destination", action: {
                    if (suggestions.isEmpty){
                        destinationInFocus = true
                        perimeter = -1
                        throwAlert = true
                    }
                    else{
                        selectedDestination = true // let user enter distance
                        selectedPerimeter = false
                    }
                })
            }
            ZStack{
                mapView
                    .ignoresSafeArea()
                // show suggested destinations when there is some text and the button hasn't been clicked
                if (!suggestions.isEmpty && !selectedDestination){
                        suggestionView(dataArray: $suggestions, mapView: mapView)
                }
                // let the user enter distance after he chose a destination but only until the distance is submitted
                if (selectedDestination && !selectedPerimeter) {
                    if let distanceView = distanceView {
                        distanceView
                    }
                }
            }
            .alert(isPresented: $throwAlert,
                   content: {
                getAlert()
            })
        } // END: View
        .onAppear(perform: { // initialize with default values
            distanceView = DistanceSelectionView(
                perimeter: $perimeter,
                selectedPerimeter: $selectedPerimeter,
                throwAlert: $throwAlert)})
        .navigationBarTitle(Text(""), displayMode: .inline)
        .navigationBarItems(trailing: Image(systemName: vehicle.getIconName()))
    }
    
    /// Helper function to create a correctly formatted alert.
    /// - Returns: Alert object with remaining distance and triggered distance info message or error message in case of worng input
    private func getAlert() -> Alert{
        
        let distance = mapAPI.getRemainingDistance()
        
        if self.perimeter == -1 {
            self.perimeter = 2.5
            return Alert(title: Text("Enter a valid destination or check your internet connection!"))
        }
        else if distance == Double.infinity{
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
                     message: Text("You will be notified " + String(format: "%.1f", self.perimeter) + " km before your destination!"),
                     primaryButton: .default(Text("OK")),
                     secondaryButton: .destructive(Text("Cancel"), action: {
            SoundManager.instance.stop()
            NotificationController.instance.setPerimeter(perimeter: 0.0)
        }))
    }
}

struct DestinationView_Previews: PreviewProvider {
    @State static var a : Bool = true
    static var previews: some View {
        DestinationView(vehicle: .Bus)
    }
}
