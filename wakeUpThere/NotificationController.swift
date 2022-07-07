//
//  NotificationController.swift
//  wakeUpThere
//
//  Created by Daniel Košč on 04/07/2022.
//

import Foundation

/// Singleton class that handles all notifications and alerts for the entire app.
class NotificationController {
    
    static let instance = NotificationController()
    
    private var remainingDistance: Double = Double.infinity
    private var perimeter: Double = 0
    
    /// Set alert perimeter trigger.
    /// - Parameter perimeter: perimeter in meters
    public func setPerimeter(perimeter: Double){
        self.perimeter = perimeter
    }
    
    /// Set the remaining distance and check if the alert should be triggered.
    /// - Parameter distance: distance in meters
    public func setRemainingDistance(distance:Double){
        self.remainingDistance = distance
        
        if (remainingDistance <= perimeter){
            SoundManager.instance.playSound()
        }
    }
}
