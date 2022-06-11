//
//  DestinationView.swift
//  wakeUpThere
//
//  Created by Daniel Košč on 09/06/2022.
//

import SwiftUI

struct DestinationView: View {
    let vehicle : TransportType
    @Binding var selected : Bool
    @State var bbb : Bool = false
    @State var destination : String = ""
    var body: some View {
        ZStack
        {
            Color.white
            VStack{
                Button(action:
                    {
                    selected.toggle()
                    }, label:{
                        Image(systemName: "arrowshape.turn.up.left")
                            .padding(.horizontal)
                            .frame( maxWidth: .infinity, alignment: .leading)
                })
                Image(systemName: vehicle.getIconName())
                TextField("Enter your \(vehicle.rawValue) final destination!", text: $destination)
                    .font(.title2)
                    .multilineTextAlignment(.center)
                MapView()
                    .ignoresSafeArea()
            }
        }
        
    }
}

struct DestinationView_Previews: PreviewProvider {
    @State static var a : Bool = true
    static var previews: some View {
        DestinationView(vehicle: .Bus, selected: $a)
    }
}
