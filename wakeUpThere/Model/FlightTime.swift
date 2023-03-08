//
//  FlightTime.swift
//  wakeUpThere
//
//  Created by Oliver Rainoch on 08.03.2023.
//

import Foundation

struct FlightTime: Codable {
    let scheduled: TimeData
   // let real: TimeData
    let estimated: TimeData
   // let other: String
}
