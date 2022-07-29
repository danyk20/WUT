//
//  TextFormatter.swift
//  wakeUpThere
//
//  Created by Daniel Košč on 28/07/2022.
//

import Foundation

class TextFormatter{
    
    /// Helper function to correctly format distance based on value. Smaller than 10 km will remain in m the bigger will be converted to the km.
    /// - Parameter distance: value in meters
    /// - Returns: formated String
    public static func formatDistnace(distance: Double) -> String{
        if distance == Double.infinity{
            return "infinity"
        }
        var formatedDistance = ""
        if distance > 10000{
            formatedDistance =  String(format: "%d", locale: Locale.current, Int(round(distance/1000))) +  " km"
        }
        else {
            formatedDistance =  String(format: "%d", locale: Locale.current, Int(round(distance))) +  " m"
        }
        return formatedDistance
    }
    
    /// Helper function to correctly format time into the string from timestamp
    /// - Parameter timestamp: timestamp in seconds
    /// - Returns: time in format H:MM or M if it is less than 1 hour
    public static func formatTime(timestamp: Double) -> String{
        if timestamp == Double.infinity{
            return "infinity"
        }
        let hours = Int(timestamp) / 3600
        let minutes = (Int(timestamp) - hours * 3600) / 60
        
        if hours > 0 {
            return "\(hours):\(String(format: "%02d", minutes))"
        }
        return "\(minutes) min"
    }
}
