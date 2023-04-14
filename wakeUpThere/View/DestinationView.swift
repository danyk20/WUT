//
//  DestinationView.swift
//  wakeUpThere
//
//  Created by Daniel Košč on 09/06/2022.
//

import SwiftUI
import MapKit

struct DestinationView: View {
    @State var mapView: MapView // map in the background
    @State private var distanceView: DistanceSelectionView = DistanceSelectionView() // view to set input perimeter
    @State private var suggestions: [Location] = [] // suggested places for user
    @State private var flightData: FlightData = FlightData.instance // selected flight info
    @State private var destination: String = "" // user input of destination
    @FocusState private var destinationInFocus: Bool // popup user keyboard
    @EnvironmentObject var travel: TravelModel // global storage
    @State private var textInput: Bool = true
    @ObservedObject var mapAPI: MapAPI = MapAPI.instance

    var body: some View {

        let inputField = TextField(getTextPromt(), text: $destination)
            .focused($destinationInFocus)
            .font(.title2)
            .multilineTextAlignment(.center)
            .disableAutocorrection(true)
            .onChange(of: destination) { _ in
                if textInput {
                    travel.state = .destinationInput
                    if getVehicle() != .airplane {
                        mapAPI.getPossiblePlaces(address: destination) { places in
                            suggestions = places
                        }
                    }
                }
                textInput = true
            }

        VStack { // START: View
            if getVehicle() == .airplane {
                HStack {
                    inputField.autocapitalization(UITextAutocapitalizationType.allCharacters)
                    if travel.state == .allSet && travel.arrivalTime != 0 {
                        Text("alert in: \(TextFormatter.formatTime(timestamp: travel.remainingTime))")
                            .padding(.horizontal)
                    }
                }
            } else {
                HStack {
                    inputField
                    if travel.state == .allSet && travel.remainingDistance != Double.infinity {
                        Text("alert in: \(TextFormatter.formatDistnace(distance: travel.remainingDistance))")
                            .padding(.horizontal)
                    }
                }
            }

            // show "set destination" button, until it is clicked
            if travel.state == .destinationInput {
                Button(getVehicle() == .airplane ? "Set selected flight number" : "Set selected destination",
                       action: {
                    destinationInFocus = false
                    if getVehicle() == .airplane {
                        if !FlightData.flightNumberCheck(flightNumber: destination.filter({!$0.isWhitespace})) {
                            travel.alertCode = 10
                            travel.throwAlert = true
                            return
                        }
                        flightData.setFlightNumber(flightNumber: destination.filter({!$0.isWhitespace}))
                        travel.state = .approachSetting
                        travel.isPerimeterSelected = false
                    } else if suggestions.isEmpty && mapAPI.locations.isEmpty {
                        destinationInFocus = true
                        travel.alertCode = -1
                        travel.throwAlert = true
                    } else {
                        travel.state = .approachSetting
                        travel.isPerimeterSelected = false
                    }
                })
            }
            ZStack {
                mapView
                    .onChange(of: mapAPI.locations) { locations in
                        // update textField only on tap gesture input
                        if travel.state == .approachSetting {
                            self.textInput = false
                            destination = locations[0].name
                        }
                    }
                    .ignoresSafeArea()
                AlertView()
                // show suggested destinations when there is some text and the button hasn't been clicked
                if !suggestions.isEmpty && travel.state == .destinationInput {
                        SuggestionView(dataArray: $suggestions)
                }
                // let the user enter distance after he chose a destination but only until the distance is submitted
                if travel.state == .approachSetting {
                    distanceView.onAppear {
                        destinationInFocus = false
                    }
                }
            }
        } // END: View
        .onAppear {
            if let target = mapAPI.locations.first {
                destination = target.name
                textInput = false
            } else {
                destinationInFocus = true
            }
        }
        .onDisappear {
            travel.state = .vehicleSelection
        }
        .navigationBarTitle(Text(""), displayMode: .inline)
        .navigationBarItems(trailing: Image(systemName: getVehicle().getIconName()))
    }

    /// Helper function to get correct Textfield promt
    /// - Returns: String promt
    private func getTextPromt() -> String {
        switch travel.vehicle {
            case .airplane:
                return "Enter your flight number!"
            default:
                return "Enter your \(getVehicle().rawValue) final destination!"
        }
    }

    /// Get currently choosen vehicle
    /// - Returns: vehicle of TransportType
    private func getVehicle() -> TransportType {
        if let vehicle = travel.vehicle {
            return vehicle
        }
        return .bus
    }
}

struct DestinationView_Previews: PreviewProvider {
    static var previews: some View {
        DestinationView(mapView: MapView()).environmentObject(TravelModel())
    }
}
