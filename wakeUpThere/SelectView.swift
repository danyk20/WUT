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
    private let prompt: String = "Choose mean of transport:"
    private let appName: String = "WUT"
    private let screenName: String = "Main screen"
    
    @StateObject private var travel: TravelModel = TravelModel()

    var body: some View {
        NavigationView{
            VStack(alignment: .center, spacing: 30) {
                Text(appName)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text(prompt)
                    .fontWeight(.bold)
                
                ForEach(TransportType.allCases, id: \.rawValue) { vehicle in
                    NavigationLink(
                        destination: DestinationView(),
                        label: {
                            RoundedRectangle(cornerRadius: 35)
                                .fill(.ultraThickMaterial)
                                .shadow(radius: 10)
                                .overlay(TransportView(transportType: vehicle)
                                    .accentColor(.primary))
                        })
                    .simultaneousGesture(TapGesture().onEnded({
                        travel.vehicle = vehicle
                    }))
                }
                
                MapView()
                    .ignoresSafeArea()
            }
            .font(.title)
            .navigationTitle(screenName)
            .navigationBarHidden(true)
        }
        .environmentObject(travel)
    }
}

struct SelectView_Previews: PreviewProvider {
    static var previews: some View {
        SelectView()
    }
}
