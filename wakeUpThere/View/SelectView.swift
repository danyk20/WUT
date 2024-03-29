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
    private var mapView: MapView = MapView()
    @StateObject private var travel: TravelModel = TravelModel()
    @StateObject var settingsController = SettingsController()
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 30) {
                Text(prompt)
                    .fontWeight(.bold)

                ForEach(TransportType.allCases, id: \.rawValue) { vehicle in
                    NavigationLink(
                        destination: DestinationView(mapView: mapView),
                        label: {
                            RoundedRectangle(cornerRadius: 35)
                                .fill(.ultraThickMaterial)
                                .shadow(radius: 10)
                                .overlay(TransportView(transportType: vehicle)
                                    .accentColor(.primary))
                        })
                    .simultaneousGesture(TapGesture().onEnded({
                        if MapAPI.instance.locations.isEmpty {
                            travel.state = .destinationInput
                        } else {
                            travel.state = .approachSetting
                        }
                        travel.vehicle = vehicle
                    }))
                }
                ZStack {
                    mapView
                        .ignoresSafeArea()
                    AlertView()
                }
            }
            .font(.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text(appName)
                            .font(.title)
                    }
                }
            }
            .navigationBarItems(trailing:
                                    HStack {
                Spacer()
                NavigationLink(destination: SettingsView(settingsController: settingsController)) {
                    Image(systemName: "gearshape")
                        .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                }
            }

            )
        }
        .environmentObject(travel)
    }
}

struct SelectView_Previews: PreviewProvider {
    static var previews: some View {
        SelectView()
    }
}
