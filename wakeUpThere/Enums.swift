//
//  Enums.swift
//  wakeUpThere
//
//  Created by Daniel Košč on 22/07/2022.
//

import Foundation

enum TransportType : String, CaseIterable{
    case Bus
    case Airplane
    case Boat
    case Train
    
    /// Get string representation of icon from library.
    /// - Returns: String name of the icon
    func getIconName () -> String
    {
        switch self {
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
}

enum ViewState : String{
    case main
    case destination
    case perimeter
    case waiting
}
