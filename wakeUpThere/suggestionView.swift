//
//  suggestionView.swift
//  wakeUpThere
//
//  Created by Daniel Košč on 19/06/2022.
//

import SwiftUI

struct suggestionView: View{
    
    @Binding var dataArray: [Location]
    @State var mapView: MapView
    
    var body: some View {
        
        VStack{
            ScrollView{
                ForEach(dataArray, id: \.self){ place in
                    Button(action: {
                        mapView.selectLocation(selectedLocation: place)
                    },label: {
                        Text("\(place.name.uppercased())  \(place.countryCode)")
                            .padding()
                            .background(Color.gray.cornerRadius(25).opacity(0.45))
                            .foregroundColor(.white)
                    })
                        .padding(5)
                        .foregroundColor(.black)
                }
            }
            .frame(maxHeight: UIScreen.main.bounds.height/5) // max 20% of the height
            Spacer()
        }
    }
}

struct suggestionView_Previews: PreviewProvider {
    static var previews: some View {
        suggestionView(dataArray: .constant(
            [Location(latitude: 0.0, longitude: 0.0, name: "Town")]), mapView: MapView())
    }
}
