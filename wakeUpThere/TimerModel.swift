//
//  TimerModel.swift
//  wakeUpThere
//
//  Created by Daniel Košč on 21/07/2022.
//

import Foundation

class TimerModel: ObservableObject{
    
    @Published var now: Date = Date()
    private var repeats: Bool = false
    private var period: Double = 10.0
    private var fligtDataPeriodUpdate: Double = Double.infinity
    private var travel: TravelModel
    
    var timer: Timer?
    init(repeats: Bool, period: Double, travel: TravelModel){
        self.travel = travel
        self.period = period
        self.repeats = repeats
    }
    
    init(period: Double, travel: TravelModel) {
        self.travel = travel
        travel.updateRemainingTime()
        if (travel.remainingTime / 2 > 10 * 60){
            fligtDataPeriodUpdate = NSDate().timeIntervalSince1970 + travel.remainingTime / 2
        }
        NotificationController.instance.periodUpdate()
        timer = Timer.scheduledTimer(withTimeInterval: period, repeats: true, block: { [self] _ in
            var errCode = 0
            if fligtDataPeriodUpdate < NSDate().timeIntervalSince1970 || errCode != 0{
                FlightData.instance.getData { errorCode in
                    errCode = errorCode
                }
                if (travel.remainingTime / 2 > 10 * 60){
                    fligtDataPeriodUpdate = NSDate().timeIntervalSince1970 + travel.remainingTime / 2
                }
                else{
                    fligtDataPeriodUpdate = Double.infinity
                }
            }
            travel.updateRemainingTime()
            NotificationController.instance.periodUpdate()
        })
    }
    
    public func runTimerAlert(){
        travel.loading = true
        timer = Timer.scheduledTimer(withTimeInterval: period, repeats: repeats, block: { [self] _ in
            travel.alertCode = FlightData.instance.getErr()
            travel.throwAlert = true
            travel.loading = false
        })
    }
    deinit {
        timer?.invalidate()
    }

}
