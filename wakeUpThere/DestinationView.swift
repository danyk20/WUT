//
//  DestinationView.swift
//  wakeUpThere
//
//  Created by Daniel Košč on 09/06/2022.
//

import SwiftUI
import MapKit

struct DestinationView: View {
    @State var mapView: MapView = MapView() // map in the background
    @State private var distanceView : DistanceSelectionView = DistanceSelectionView() // view to set input perimeter
    @State private var suggestions: [Location] = [] // suggested places for user
    @State private var flightData: FlightData = FlightData.instance // selected flight info
    @State private var destination : String = "" // user input of destination
    @State private var selectedDestination: Bool = false // user set destination
    @FocusState private var destinationInFocus: Bool // popup user keyboard
    @EnvironmentObject var travel: TravelModel // global storage
    var mapAPI: MapAPI = MapAPI.instance
    
    var body: some View {
        // watch the value of TextField, and if it has been changed, trigger these events
        let binding = Binding<String>(get: {
                    self.destination
                }, set: {
                    travel.state = .destinationInput
                    selectedDestination = false // show again destination list
                    self.destination = $0
                    if (getVehicle() != .Airplane){
                        mapAPI.getPossiblePlaces(address: destination) { places in
                            suggestions = places
                        }
                    }
                })
        
        let inputField = TextField(getTextPromt(), text: binding)
            .focused($destinationInFocus)
            .font(.title2)
            .multilineTextAlignment(.center)
            .disableAutocorrection(true)
        
        VStack{ // START: View
            
            if (getVehicle() == .Airplane){
                HStack{
                    inputField.autocapitalization(UITextAutocapitalizationType.allCharacters)
                    if travel.state == .allSet && travel.arrivalTime != 0 {
                        Text("remaining : \(TextFormatter.formatTime(timestamp: travel.remainingTime))")
                            .padding(.horizontal)
                    }
                }
            }
            else {
                HStack{
                    inputField
                    if travel.state == .allSet && travel.remainingDistance != Double.infinity{
                        Text("remaining : \(TextFormatter.formatDistnace(distance:travel.remainingDistance))")
                            .padding(.horizontal)
                    }
                }
            }
                
            // show "set destination" button, until it is clicked
            if !selectedDestination {
                Button(getVehicle() == .Airplane ? "Set selected flight number" : "Set selected destination",
                       action: {
                    if (getVehicle() == .Airplane){
                        if !FlightData.flightNumberCheck(flightNumber: destination.filter({!$0.isWhitespace})){
                            travel.alertCode = 10
                            travel.throwAlert = true
                            return
                        }
                        flightData.setFlightNumber(flightNumber: destination.filter({!$0.isWhitespace}))
                        selectedDestination = true // let user enter distance
                        travel.isPerimeterSelected = false
                    } else if (suggestions.isEmpty){
                        destinationInFocus = true
                        travel.alertCode = -1
                        travel.throwAlert = true
                    }
                    else{
                        selectedDestination = true // let user enter distance
                        travel.isPerimeterSelected = false
                    }
                })
            }
            ZStack{
                if travel.state != .vehicleSelection{
                    mapView
                        .ignoresSafeArea()
                    AlertView()
                }
                // show suggested destinations when there is some text and the button hasn't been clicked
                if (!suggestions.isEmpty && !selectedDestination){
                        suggestionView(dataArray: $suggestions)
                }
                // let the user enter distance after he chose a destination but only until the distance is submitted
                if (selectedDestination && !travel.isPerimeterSelected) {
                    distanceView
                }
            }
        } // END: View
        .onDisappear(){
            travel.state = .vehicleSelection
        }
        .navigationBarTitle(Text(""), displayMode: .inline)
        .navigationBarItems(trailing: Image(systemName: getVehicle().getIconName()))
    }
    
    /// Helper function to get correct Textfield promt
    /// - Returns: String promt
    private func getTextPromt() -> String{
        switch travel.vehicle {
        case .Airplane:
            return "Enter your flight number!"
        default:
            return "Enter your \(getVehicle().rawValue) final destination!"
        }
    }
    
    /// Get currently choosen vehicle
    /// - Returns: vehicle of TransportType
    private func getVehicle() -> TransportType{
        if let vehicle = travel.vehicle{
            return vehicle
        }
        return .Bus
    }
}

struct DestinationView_Previews: PreviewProvider {
    static var previews: some View {
        DestinationView()
    }
}
