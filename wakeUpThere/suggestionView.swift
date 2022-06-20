//
//  suggestionView.swift
//  wakeUpThere
//
//  Created by Daniel Košč on 19/06/2022.
//

import SwiftUI

struct suggestionView: View{
    @Binding var dataArray: [Datum]
    @State var mapView: MapView
    var body: some View {
        
        VStack{
            ScrollView{
                ForEach(dataArray, id: \.self){ place in
                    Button(action: {
                        mapView.selectPlace(selectedLocation: place)
                    },label: {
                        Text(place.name.uppercased())
                            .padding()
                            .background(Color.gray.cornerRadius(25).opacity(0.45))
                            .foregroundColor(.white)
                    })
                        .padding(5)
                        .foregroundColor(.black)
                }
            }
            .frame(maxHeight: UIScreen.main.bounds.height/5)
            Spacer()
        }
        
    }
}

struct suggestionView_Previews: PreviewProvider {
    static var b: Double = 0.0
    static var a: Double = 0.0
    static var previews: some View {
        
        suggestionView(dataArray: .constant([Datum(latitude: 0.0, longitude: 0.0, name: "Mesto")]), mapView: MapView())
    }
}
