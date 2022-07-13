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
                        destination: DestinationView(vehicle: vehicle),
                        label: {
                            RoundedRectangle(cornerRadius: 35)
                                .fill(.ultraThickMaterial)
                                .shadow(radius: 10)
                                .overlay(TransportView(transportType: vehicle)
                                    .accentColor(.primary))
                        })
                }
                
                MapView()
                    .ignoresSafeArea()
            }
            .font(.title)
            .navigationTitle(screenName)
            .navigationBarHidden(true)
        }
    }
}

struct SelectView_Previews: PreviewProvider {
    static var previews: some View {
        SelectView()
    }
}
