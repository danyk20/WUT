//
//  SelectView.swift
//  wakeUpThere
//
//  Created by Daniel Košč on 22/05/2022.
//

import SwiftUI
import MapKit
import CoreLocationUI

struct SelectView: View {
    @StateObject private var mapModel = MapViewModel()
    @State private var selectedTransportType = "Choose mean of transport:"
    @State private var selectedVehicle : TransportType? = nil
    @State var selected : Bool = false

    var body: some View {
        ZStack{
            VStack(alignment: .center, spacing: 30) {
                Text("WUT")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text(selectedTransportType)
                    .fontWeight(.bold)
                
                ForEach(TransportType.allCases, id: \.rawValue) { vehicle in
                    Button(action: {
                        selected = true
                        selectedVehicle = vehicle
                        selectedTransportType = vehicle.rawValue
                    }, label: {
                        RoundedRectangle(cornerRadius: 35)
                            .fill(Color.white)
                            .shadow(radius: 10)
                            .overlay(TransportView(transportType: vehicle)
                                .accentColor(Color.black))
                    }
                    )
                        }
                
                MapView()
                    .ignoresSafeArea()
            }
            .font(.title)
            ZStack{
                if selected{
                    DestinationView(vehicle: selectedVehicle!, selected: $selected)
                        .transition(.move(edge: .trailing))
                        .animation(.spring()) // , value = "what is changed"

                }
            }
            .zIndex(2.0)
            
        }
        
        
        
    }
}

struct SelectView_Previews: PreviewProvider {
    static var previews: some View {
        SelectView()
            
    }
}


