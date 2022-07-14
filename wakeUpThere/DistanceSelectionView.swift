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
    
    private let minDistance: Double = 1
    private let maxDistance: Double = 100
    @Binding var perimeter: Double
    @Binding var selectedPerimeter: Bool
    @Binding var throwAlert: Bool
    @ObservedObject var input = NumbersOnly()
    
    var body: some View {
        VStack {
            VStack{
                Text("Perimeter:")
                    .font(.title)
                HStack {
                    TextField(String(format: "%.1f", perimeter), text: $input.value)
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
                           step: 0.1,
                           onEditingChanged: { (_) in
                        input.value = String(format: "%.1f", perimeter)
                    },
                           minimumValueLabel: Text("\(String(format: "%.1f", minDistance)) km "),
                           maximumValueLabel: Text(" \(String(format: "%.1f", maxDistance)) km "),
                           label: {})
                    .padding(.horizontal)
                }
            }            .background(.ultraThinMaterial)
            Spacer()
        }
    }
}

struct DistanceSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        DistanceSelectionView(perimeter: .constant(2.5), selectedPerimeter: .constant(false), throwAlert: .constant(false))
    }
}
