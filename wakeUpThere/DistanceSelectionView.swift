//
//  DistanceSelectionView.swift
//  wakeUpThere
//
//  Created by Daniel Košč on 01/07/2022.
//

import SwiftUI

/// Class to allow only numeric values in the textField.
class NumbersOnly: ObservableObject {
    @Published var value = "" {
        didSet {
            let filtered = value.filter { $0.isNumber ||  $0 == "."}
            
            if value != filtered {
                value = filtered
            }
        }
    }
}

struct DistanceSelectionView: View {
    
    @EnvironmentObject var travel: TravelModel
    
    private let minDistance: Double = 1
    private let maxDistance: Double = 100
    @State var decimalPlaces: Int = 1
    @State var unit: String = "km"
    @State var title: String = "Perimeter:"
    @Binding var perimeter: Double
    @Binding var selectedPerimeter: Bool
    @Binding var throwAlert: Bool
    @ObservedObject var input = NumbersOnly()
    
    var body: some View {
        VStack {
            VStack{
                Text(title)
                    .font(.title)
                HStack {
                    TextField(String(format: "%.\(decimalPlaces)f", perimeter), text: $input.value)
                        .padding()
                        .overlay(RoundedRectangle(cornerRadius: 10.0).strokeBorder())
                        .padding()
                    .keyboardType(.decimalPad)
                    Button {
                        selectedPerimeter = true
                        throwAlert = true
                        NotificationController.instance.setPerimeter(perimeter: perimeter * 1000)
                    } label: {
                        Text("Submit")
                            .padding()
                            .background(
                                Capsule(style: .continuous)
                                    .fill(.regularMaterial)
                                    .shadow(
                                        color: .gray,
                                        radius: 3
                                    )
                            )
                    }
                    .padding()
                }
        
                HStack {
                    Slider(value: $perimeter,
                           in: minDistance...maxDistance,
                           step: travel.vehicle == .Airplane ? 1 : 0.1,
                           onEditingChanged: { (_) in
                        input.value = String(format: "%.\(decimalPlaces)f", perimeter)
                    },
                           minimumValueLabel: Text("\(String(format: "%.\(decimalPlaces)f", minDistance)) \(unit) "),
                           maximumValueLabel: Text(" \(String(format: "%.\(decimalPlaces)f", maxDistance)) \(unit) "),
                           label: {})
                    .padding(.horizontal)
                }
            }            .background(.ultraThinMaterial)
            Spacer()
        }
        .onAppear(){
            if travel.vehicle == .Airplane{
                unit = "min"
                decimalPlaces = 0
                title = "Time prior to arrival:"
            }
        }
    }
}

struct DistanceSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        DistanceSelectionView(perimeter: .constant(2.5), selectedPerimeter: .constant(false), throwAlert: .constant(false))
    }
}
