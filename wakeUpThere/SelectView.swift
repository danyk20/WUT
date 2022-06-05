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

    var body: some View {
        VStack(alignment: .center, spacing: 50) {
            Text("WUT")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Choose mean of transport:")
                .fontWeight(.bold)
            
            ForEach(TransportType.allCases, id: \.rawValue) { vehicle in
                        TransportView(transportType: vehicle)
                    }
            
            MapView()
        }
        .font(.title)
        
    }
}

struct SelectView_Previews: PreviewProvider {
    static var previews: some View {
        SelectView()
            
    }
}


