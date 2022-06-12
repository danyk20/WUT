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
    @State private var selectedVehicle : TransportType? = nil
    @State private var selected = false
    
    private let prompt = "Choose mean of transport:"

    var body: some View {
        ZStack{
            VStack(alignment: .center, spacing: 30) {
                Text("WUT")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text(prompt)
                    .fontWeight(.bold)
                
                ForEach(TransportType.allCases, id: \.rawValue) { vehicle in
                    Button{
                        selectedVehicle = vehicle
                        selected = true
                    } label: {
                        RoundedRectangle(cornerRadius: 35)
                            .fill(Color.white)
                            .shadow(radius: 10)
                            .overlay(TransportView(transportType: vehicle)
                                .accentColor(Color.black))
                    }
                }
                
                MapView()
                    .ignoresSafeArea()
            }
            .font(.title)
            ZStack{
                if selected{
                    DestinationView(vehicle: selectedVehicle!, selected: $selected)
                        .transition(.move(edge: .trailing))
                }
            }
            .animation(.spring(), value: selected)
            .zIndex(2.0)
            
        }
    }
}

struct SelectView_Previews: PreviewProvider {
    static var previews: some View {
        SelectView()
            
    }
}


