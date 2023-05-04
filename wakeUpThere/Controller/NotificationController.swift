//
//  NotificationController.swift
//  wakeUpThere
//
//  Created by Daniel Košč on 04/07/2022.
//

import Foundation
import SwiftUI
import CoreLocation

/// Singleton class that handles all notifications and alerts for the entire app.
class NotificationController: NSObject, ObservableObject {

    static let instance = NotificationController()
    private var remainingDistance: Double = Double.infinity
    private var timeUpdater: TimerModel?
    var travel: TravelModel? // global storage
    let notificationCenter = UNUserNotificationCenter.current()
    var selectedDistanceForNotification: Double = 0

    /// Adding global varibale to the class
    /// - Parameter travel: reference on global variable
    public func setTravelModel(travel: TravelModel) {
        self.travel = travel
    }

    /// Set flight arrival time and start periodic check but must follow afther setTraveModel function
    /// - Parameter arrival: arrival time as timestamp
    public func startPeriodicalUpdate(arrival: Double) {
        if travel?.arrivalTime != arrival {
            travel?.arrivalTime = arrival
        }
        if timeUpdater == nil {
            if let travel = self.travel {
                timeUpdater = TimerModel(period: 60.0, travel: travel)
            }
        }
    }

    /// Set the remaining distance and check if the alert should be triggered.
    /// - Parameter distance: distance in km
    /// - Returns: true if the user enter perimeter otherwise false
    public func setRemainingDistance(distance: Double) -> Bool {
        self.remainingDistance = distance
        if let perimeter = self.travel?.perimeter {
            if remainingDistance <= perimeter * 1000 {
                SoundManager.instance.playSound()
                return true
            }
        }
        return false
    }

    /// Periodic check of flight arrival time, in case that arival time is triggered then user is notified
    /// - Returns: notification triggered
    public func periodUpdate() -> Bool {
        if let travel = travel {
            if travel.remainingTime <= 0 {
                SoundManager.instance.playSound()
                travel.alertCode = -2
                travel.throwAlert = true
                timeUpdater = nil
                return true
            }
        }
        return false
    }

    public func requestNotificationAuthorization() {
        let options: UNAuthorizationOptions = [.sound, .alert]
        notificationCenter
            .requestAuthorization(options: options) { [weak self] result, _ in
                print("Auth Request result: \(result)")
                if result {
                    guard let selectedLocation = self?.travel?.destination else { return }
                    self?.registerNotification(selectedLocation: selectedLocation)
                }
            }
    }

    private func registerNotification(selectedLocation: Location) {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "You arrived at the location"
        notificationContent.body = "You are here!"
        notificationContent.sound = .default

        let trigger = UNLocationNotificationTrigger(region: makeStoreRegion(selectedLocation: selectedLocation), repeats: false)

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: notificationContent,
            trigger: trigger)

        notificationCenter
            .add(request) { error in
                if error != nil {
                    print("Error: \(String(describing: error))")
                }
            }
    }

    private func makeStoreRegion(selectedLocation: Location) -> CLCircularRegion {
        let region = CLCircularRegion(
            center: selectedLocation.getCoordinates2D(),
            radius: (travel?.perimeter ?? 2.5) * 1000,
            identifier: UUID().uuidString)
        region.notifyOnEntry = true
        return region
    }
}

extension NotificationController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        print("Received Notification")
        completionHandler()
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler:
        @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        print("Received Notification in Foreground")
        completionHandler(.sound)
    }
}
