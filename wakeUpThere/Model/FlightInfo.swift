//
//  FlightInfo.swift
//  wakeUpThere
//
//  Created by Oliver Rainoch on 08.03.2023.
//

import Foundation

struct FlightInfo: Codable {
    // let item: String
    // let page: String
    let timestamp: Int
    let data: [Flight]
    // let aircraftInfo: String
    // let aircraftImages
}
