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
    @State private var flightData: FlightData = FlightData.instance // selected flight info
    @State private var destination : String = "" // user input of destination
    @State private var buttonText = "Set selected" // submit button text
    @State private var selectedDestination: Bool = false // user set destination
    @State private var selectedPerimeter: Bool = false // user set perimeter
    @State private var throwAlert: Bool = false // show some alert to the user
    @State private var perimeter: Double = 2.5 // in km
    @FocusState private var destinationInFocus: Bool
    @EnvironmentObject var travel: TravelModel
    var mapAPI: MapAPI = MapAPI.instance
    
    var body: some View {
        // watch the value of TextField, and if it has been changed, trigger these events
        let binding = Binding<String>(get: {
                    self.destination
                }, set: {
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
                        selectedPerimeter = false
                    } else if (suggestions.isEmpty){
                        destinationInFocus = true
                        perimeter = -1
                        throwAlert = true
                    }
                    else{
                        selectedDestination = true // let user enter distance
                        selectedPerimeter = false
                    }
                })
                .onAppear{
                    switch getVehicle() {
                    case .Airplane:
                        buttonText += " flight number"
                    default:
                        buttonText += " destination"
                    }
                }
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
        .onAppear(perform: {
            // initialize with default values
            distanceView = DistanceSelectionView(
                perimeter: $perimeter,
                selectedPerimeter: $selectedPerimeter,
                throwAlert: $throwAlert)
        })
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
    
    /// Helper function to create a correctly formatted alert.
    /// - Returns: Alert object with remaining distance and triggered distance info message or error message in case of worng input
    private func getAlert() -> Alert{
        
        if getVehicle() == .Airplane{
            if flightData.isProblem(){
                return Alert(title: Text("Enter a valid flight number or check your internet connection!"))
            }
            return Alert(title: Text("Your expected arrival is \(flightData.getArrivalTime())"),
                         message: Text("You will get a notification \(Int(perimeter)) min prior to the arrival."))
        }
        else{
            let distance = mapAPI.getRemainingDistance()
            
            if self.perimeter == -1 {
                self.perimeter = 2.5
                return Alert(title: Text("Enter a valid destination or check your internet connection!"))
            }
            else if distance == Double.infinity{
                return Alert(title: Text("Error ocurred try again later!"))
            }
            return Alert(title: Text("Remaining distance is: \(formatDistnace(distance:distance))"),
                         message: Text("You will be notified " + String(format: "%.1f", self.perimeter) + " km before your destination!"),
                         primaryButton: .default(Text("OK")),
                         secondaryButton: .destructive(Text("Cancel"), action: {
                SoundManager.instance.stop()
                NotificationController.instance.setPerimeter(perimeter: 0.0)
            }))

        }
    }
}

/// Helper function to correctly format distance based on value. Smaller than 10 km will remain in m the bigger will be converted to the km.
/// - Parameter distance: value in meters
/// - Returns: formated String
private func formatDistnace(distance: Double) -> String{
    var formatedDistance = ""
    if distance > 10000{
        formatedDistance =  String(format: "%d", locale: Locale.current, Int(round(distance/1000))) +  " km"
    }
    else {
        formatedDistance =  String(format: "%d", locale: Locale.current, Int(round(distance))) +  " m"
    }
    return formatedDistance
}

struct DestinationView_Previews: PreviewProvider {
    static var previews: some View {
        DestinationView()
    }
}
