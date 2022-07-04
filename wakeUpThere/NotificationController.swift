//
//  NotificationController.swift
//  wakeUpThere
//
//  Created by Daniel Košč on 04/07/2022.
//

import Foundation

class NotificationController {
    
    static let instance = NotificationController()
    
    private var remainingDistance: Double = Double.infinity
    private var perimeter: Double = 0
    
    public func setPerimeter(perimeter: Double){
        self.perimeter = perimeter
    }
    
    public func setRemainingDistance(distance:Double){
        self.remainingDistance = distance
        
        if (remainingDistance <= perimeter){
            SoundManager.instance.playSound()
        }
    }
}
