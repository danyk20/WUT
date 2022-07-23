//
//  TimerModel.swift
//  wakeUpThere
//
//  Created by Daniel Košč on 21/07/2022.
//

import Foundation

class TimerModel: ObservableObject{
    
    @Published var now: Date = Date()
    
    var timer: Timer?
    init(period: Double) {
        timer = Timer.scheduledTimer(withTimeInterval: period, repeats: true, block: { _ in
            NotificationController.instance.periodUpdate()
        })
    }
    deinit {
        timer?.invalidate()
    }

}
