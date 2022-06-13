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
        NavigationView{
            VStack(alignment: .center, spacing: 30) {
                Text("WUT")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text(prompt)
                    .fontWeight(.bold)
                
                ForEach(TransportType.allCases, id: \.rawValue) { vehicle in
                    NavigationLink(
                        destination: DestinationView(vehicle: vehicle),
                        label: {
                            RoundedRectangle(cornerRadius: 35)
                                .fill(Color.white)
                                .shadow(radius: 10)
                                .overlay(TransportView(transportType: vehicle)
                                    .accentColor(Color.black))
                        })
                }
                
                MapView()
                    .ignoresSafeArea()
            }
            .font(.title)
            .navigationTitle("Main screen")
            .navigationBarHidden(true)
        }
    }
}

struct SelectView_Previews: PreviewProvider {
    static var previews: some View {
        SelectView()
            
    }
}


