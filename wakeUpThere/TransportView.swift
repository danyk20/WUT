//
//  TransportView.swift
//  wakeUpThere
//
//  Created by Daniel Košč on 04/06/2022.
//

import SwiftUI

struct TransportView: View {
    
    let transportType: TransportType
    
    func getIconName (vehicle: TransportType) -> String
    {
        switch vehicle {
        case .Bus:
            return "bus"
        case .Airplane:
            return "airplane"
        case .Boat:
            return "ferry.fill"
        case .Train:
            return "tram"
        }
    }
    
    var body: some View {
        HStack{
            Image(systemName: getIconName(vehicle: transportType))
            Text("\(transportType.rawValue)")
                .fontWeight(.bold)
        }
    }
}

struct TransportView_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            TransportView(transportType: TransportType.Boat)
            TransportView(transportType: TransportType.Bus)
        }
    }
}
