//
//  Transport.swift
//  wakeUpThere
//
//  Created by Daniel Košč on 04/06/2022.
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
