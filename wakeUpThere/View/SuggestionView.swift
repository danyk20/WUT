//
//  suggestionView.swift
//  wakeUpThere
//
//  Created by Daniel Košč on 19/06/2022.
//

import SwiftUI

struct SuggestionView: View {

    @Binding var dataArray: [Location]
    let mapAPI: MapAPI = MapAPI.instance

    var body: some View {
        VStack {
            ScrollView {
                ForEach(dataArray, id: \.self) { place in
                    Button(action: {
                        mapAPI.setDestination(selectedLocation: place)
                    }, label: {
                        Text("\(place.name.uppercased())  \(place.countryCode)")
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(25)
                    })
                        .padding(5)
                        .foregroundColor(.primary)
                }
            }
            .frame(maxHeight: UIScreen.main.bounds.height/5) // max 20% of the height
            Spacer()
        }
    }
}

struct SuggestionView_Previews: PreviewProvider {
    static var previews: some View {
        SuggestionView(dataArray: .constant(
            [Location(latitude: 0.0, longitude: 0.0, name: "Town")]))
    }
}
