//
//  Enums.swift
//  wakeUpThere
//
//  Created by Daniel Košč on 22/07/2022.
//

import Foundation

enum TransportType: String, CaseIterable {
    case bus
    case airplane
    case boat
    case train

    /// Get string representation of icon from library.
    /// - Returns: String name of the icon
    func getIconName () -> String {
        switch self {
            case .bus:
                return "bus"
            case .airplane:
                return "airplane"
            case .boat:
                return "ferry.fill"
            case .train:
                return "tram"
        }
    }
}

enum ViewState: String {
    case vehicleSelection
    case destinationInput
    case approachSetting
    case allSet
}
