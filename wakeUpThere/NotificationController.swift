//
//  NotificationController.swift
//  wakeUpThere
//
//  Created by Daniel Košč on 04/07/2022.
//

import Foundation
import SwiftUI

/// Singleton class that handles all notifications and alerts for the entire app.
class NotificationController: ObservableObject{
    
    static let instance = NotificationController()
    
    private var remainingDistance: Double = Double.infinity
    private var perimeter: Double = 0
    private var arrivalTime: Double = 0
    private var timeUpdater: TimerModel? = nil
    
    var travel: TravelModel? // global storage
    
    /// Adding global varibale to the class
    /// - Parameter travel: reference on global variable
    public func setTravelModel(travel: TravelModel){
        self.travel = travel
    }
    
    /// Set flight arrival time and start periodic check
    /// - Parameter arrival: arrival time as timestamp
    public func setArrivalTime(arrival: Double){
        self.arrivalTime = arrival
        timeUpdater = TimerModel(period: 60.0)
    }
    
    /// Set alert perimeter trigger.
    /// - Parameter perimeter: perimeter in meters
    public func setPerimeter(perimeter: Double){
        self.perimeter = perimeter
    }
    
    /// Set the remaining distance and check if the alert should be triggered.
    /// - Parameter distance: distance in meters
    /// - Returns: true if the user enter perimeter otherwise false
    public func setRemainingDistance(distance:Double) -> Bool{
        self.remainingDistance = distance
        
        if (remainingDistance <= perimeter){
            SoundManager.instance.playSound()
            return true
        }
        
        return false
    }
    
    /// Periodic check of flight arrival time, in case that arival time is triggered then user is notified
    public func periodUpdate(){
        if Double(arrivalTime) <= Date().timeIntervalSince1970 + perimeter * 60 {
            SoundManager.instance.playSound()
            if let travel = travel {
                travel.alertCode = -2
                travel.throwAlert = true
            }
            
        }
    }
    
    /// Allert to notify the user after entering the set perimeter.
    /// - Parameters:
    ///   - title: alert title text
    ///   - message: alert message text
    /// - Returns: Alert object with button to stop text and sound notification
    public static func getAlert(title: String, message: String) -> Alert{
        return Alert(title: Text(title),
                     message: Text(message),
                     dismissButton:  .default(Text("Stop"), action: {
            SoundManager.instance.stop()
            NotificationController.instance.setPerimeter(perimeter: 0.0)
        }))
    }
}
