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
    @State private var distanceView : DistanceSelectionView? // view to set input perimeter
    @State private var suggestions: [Location] = [] // suggested places for user
    @State private var flightData: FlightData = FlightData.instance // selected flight info
    @State private var destination : String = "" // user input of destination
    @State private var buttonText = "submit" // submit button text
    @State private var selectedDestination: Bool = false // user set destination
    @FocusState private var destinationInFocus: Bool // popup user keyboard
    @EnvironmentObject var travel: TravelModel // global storage
    var mapAPI: MapAPI = MapAPI.instance
    
    var body: some View {
        // watch the value of TextField, and if it has been changed, trigger these events
        let binding = Binding<String>(get: {
                    self.destination
                }, set: {
                    travel.state = .destination
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
                inputField.autocapitalization(UITextAutocapitalizationType.allCharacters)
            }
            else {
                inputField
            }
                
            // show "set destination" button, until it is clicked
            if !selectedDestination {
                Button(buttonText, action: {
                    if (getVehicle() == .Airplane){
                        flightData.setFlightNumber(flightNumber: destination)
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
                .onAppear{
                    distanceView =  DistanceSelectionView()
                    switch getVehicle() {
                    case .Airplane:
                        buttonText = "Set selected flight number"
                    default:
                        buttonText = "Set selected destination"
                    }
                }
            }
            ZStack{
                if travel.state != .main{
                    AlertView()
                    mapView
                        .ignoresSafeArea()
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
            travel.state = .main
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
