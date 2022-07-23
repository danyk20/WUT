//
//  TravelModel.swift
//  wakeUpThere
//
//  Created by Daniel Košč on 18/07/2022.
//

import Foundation

class TravelModel: ObservableObject{
    
    init(){
        perimeter = 2.5
        isPerimeterSelected = false
        throwAlert = false
        arrivalTime = 0
        alertCode = 0
        state = .main
    }
    
    @Published var vehicle: TransportType?
    @Published var perimeter: Double
    @Published var isPerimeterSelected: Bool
    @Published var throwAlert: Bool
    @Published var arrivalTime: Int
    @Published var alertCode: Int
    @Published var state: ViewState
}
