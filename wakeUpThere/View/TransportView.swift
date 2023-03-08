//
//  TransportView.swift
//  wakeUpThere
//
//  Created by Daniel Košč on 04/06/2022.
//

import SwiftUI

struct TransportView: View {

    let transportType: TransportType

    var body: some View {
        HStack {
            Image(systemName: transportType.getIconName())
            Text("\(transportType.rawValue)")
                .fontWeight(.bold)
        }
    }
}

struct TransportView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TransportView(transportType: .boat)
            TransportView(transportType: .bus)
        }
    }
}
