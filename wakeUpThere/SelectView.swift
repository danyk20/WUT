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
                Map(coordinateRegion: $mapModel.region, showsUserLocation: true)
                    .ignoresSafeArea()
                    .onAppear{
                        mapModel.chcekIfLocationServicesIsEnable()
                    }
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


