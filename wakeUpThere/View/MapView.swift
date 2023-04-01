//
//  MapView.swift
//  wakeUpThere
//
//  Created by Daniel Košč on 04/06/2022.
//

import SwiftUI
import MapKit
import CoreLocationUI

struct MapView: View {
    @State public var map: BackgroundMap = BackgroundMap()

    init() {
        print("Initilizing  mapView")
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            map
            VStack { // zoom in/out buttons
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        self.map.zoomIn()
                    }, label: {
                        Image(systemName: "plus.magnifyingglass")
                            .font(.title)
                    })
                    .padding()
                }
                HStack {
                    Spacer()
                    Button(action: {
                        self.map.zoomOut()
                    }, label: {
                        Image(systemName: "minus.magnifyingglass")
                            .font(.title)
                    })
                    .padding()
                }
            }

        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView().environmentObject(TravelModel())
    }
}
