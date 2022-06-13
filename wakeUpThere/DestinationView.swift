//
//  DestinationView.swift
//  wakeUpThere
//
//  Created by Daniel Košč on 09/06/2022.
//

import SwiftUI

struct DestinationView: View {
    let vehicle : TransportType
    @State var bbb : Bool = false
    @State var destination : String = ""
    var body: some View {
        VStack{
            TextField("Enter your \(vehicle.rawValue) final destination!", text: $destination)
                .font(.title2)
                .multilineTextAlignment(.center)
            MapView()
                .ignoresSafeArea()
        }
//        .navigationTitle(_: Image(systemName: TransportType.Bus.getIconName()))
        .navigationBarTitle(Text(""), displayMode: .inline)
        .navigationBarItems(trailing: Image(systemName: vehicle.getIconName()))
        
        
    }
}

struct DestinationView_Previews: PreviewProvider {
    @State static var a : Bool = true
    static var previews: some View {
        DestinationView(vehicle: .Bus)
    }
}
