//
//  TimerModel.swift
//  wakeUpThere
//
//  Created by Daniel Košč on 21/07/2022.
//

import Foundation

class TimerModel {
    private var repeats: Bool = false
    private var period: Double = 10.0
    private var fligtDataPeriodUpdate: Double = Double.infinity
    private var travel: TravelModel

    var timer: Timer?
    init(repeats: Bool, period: Double, travel: TravelModel) {
        self.travel = travel
        self.period = period
        self.repeats = repeats
    }

    init(period: Double, travel: TravelModel) {
        let flightAPI = FlightData.instance
        self.travel = travel
        if travel.remainingTime / 2 > 10 * 60 {
            fligtDataPeriodUpdate = NSDate().timeIntervalSince1970 + travel.remainingTime / 2
        }
        if !NotificationController.instance.periodUpdate() {
            timer = Timer.scheduledTimer(withTimeInterval: period, repeats: true, block: { [self] _ in
                travel.updateRemainingTime()
                var errCode = 0
                if fligtDataPeriodUpdate < NSDate().timeIntervalSince1970 || errCode != 0 {
                    flightAPI.getData { errorCode in
                        errCode = errorCode
                    }
                    travel.arrivalTime = Double(flightAPI.getExpectedArrivalTimestamp())
                    if travel.remainingTime / 2 > 10 * 60 {
                        fligtDataPeriodUpdate = NSDate().timeIntervalSince1970 + travel.remainingTime / 2
                    } else {
                        fligtDataPeriodUpdate = Double.infinity
                    }
                }
                if NotificationController.instance.periodUpdate() {
                    stop()
                    timer = nil
                }
            })
        }
    }

    public func runTimerAlert() {
        travel.loading = true
        timer = Timer.scheduledTimer(withTimeInterval: period, repeats: repeats, block: { [self] _ in
            travel.alertCode = FlightData.instance.getErr()
            travel.throwAlert = true
            travel.loading = false
        })
    }

    public func stop() {
        timer?.invalidate()
    }
    deinit {
        stop()
    }
}
