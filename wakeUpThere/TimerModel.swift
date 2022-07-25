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
    private var travel: TravelModel = TravelModel()
    
    var timer: Timer?
    init(repeats: Bool, period: Double, travel: TravelModel){
        self.travel = travel
        self.period = period
        self.repeats = repeats
    }
    
    init(period: Double) {
        timer = Timer.scheduledTimer(withTimeInterval: period, repeats: true, block: { _ in
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
