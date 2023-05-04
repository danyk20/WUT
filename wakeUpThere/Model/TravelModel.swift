//
//  TravelModel.swift
//  wakeUpThere
//
//  Created by Daniel Košč on 18/07/2022.
//

import Foundation

class TravelModel: ObservableObject {

    init() {
        perimeter = 2.5
        isPerimeterSelected = false
        throwAlert = false
        arrivalTime = 0
        alertCode = 0
        state = .vehicleSelection
        loading = false
        remainingDistance = 0
        remainingTime = 0
    }

    @Published var vehicle: TransportType?
    @Published var perimeter: Double
    @Published var remainingDistance: Double
    @Published var remainingTime: Double
    @Published var isPerimeterSelected: Bool
    @Published var throwAlert: Bool
    @Published var loading: Bool
    @Published var arrivalTime: Double {
        didSet {
            self.updateRemainingTime()
        }
    }
    @Published var alertCode: Int
    @Published var state: ViewState
    var destination: Location?

    /// Reset all values except of state
    public func reset() {
        perimeter = 2.5
        isPerimeterSelected = false
        throwAlert = false
        arrivalTime = 0
        alertCode = 0
        loading = false
        remainingDistance = 0
        remainingTime = 0
    }

    public func updateRemainingTime() {
        remainingTime = arrivalTime - perimeter * 60 - NSDate().timeIntervalSince1970
    }
}
