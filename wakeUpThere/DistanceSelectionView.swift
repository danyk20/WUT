//
//  DistanceSelectionView.swift
//  wakeUpThere
//
//  Created by Daniel Košč on 01/07/2022.
//

import SwiftUI

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
    @Binding var perimeter: Double
    @Binding var selectedPerimeter: Bool
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
                        selectedPerimeter.toggle()
                        NotificationController.instance.setPerimeter(perimeter: perimeter * 1000)
                    } label: {
                        Text("Submit")
                            .padding()
                            .background(
                                Capsule(style: .continuous)
                                    .fill(.white)
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
                           in: 1...100,
                           step: 0.1,
                           onEditingChanged: { (_) in
                        input.value = String(format: "%.1f", perimeter)
                    },
                           minimumValueLabel: Text("1 km "),
                           maximumValueLabel: Text(" 100 km"),
                           label: {})
                    .padding(.horizontal)
                }
            }            .background(Color.white.opacity(0.65))
            Spacer()
        }
    }
}

struct DistanceSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        DistanceSelectionView(perimeter: .constant(2.5), selectedPerimeter: .constant(false))
    }
}
