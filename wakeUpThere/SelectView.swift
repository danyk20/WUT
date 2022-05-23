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
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 39.8, longitude: -92.8), span: MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2))
    var body: some View {
        VStack(alignment: .center, spacing: 50) {
            Text("WUT")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Choose mean of transport:")
                .fontWeight(.bold)
            
            HStack{
                Image(systemName: "ferry.fill")
                Text("Boat")
                    .fontWeight(.bold)
            }
            
            HStack{
                Image(systemName: "bus")
                Text("Bus")
                    .fontWeight(.bold)
            }
            
            HStack{
                Image(systemName: "tram")
                Text("Train")
                    .fontWeight(.bold)
            }
            
            HStack{
                Image(systemName: "airplane")
                Text("Airplane")
                    .fontWeight(.bold)
            }
            
            ZStack(alignment: .bottom){
                Map(coordinateRegion: $region, showsUserLocation: true)
                    .ignoresSafeArea()
            }
        }
        .font(.title)
        
    }
}

struct SelectView_Previews: PreviewProvider {
    static var previews: some View {
        SelectView()
            
    }
}
