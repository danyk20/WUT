//
//  NotificationXontrollerTests.swift
//  wakeUpThereTests
//
//  Created by Oliver Rainoch on 19.03.2023.
//

import Foundation
import XCTest

@testable import wakeUpThere

class NotificationControllerTests: XCTestCase {

    let notificationController = NotificationController()
    var travelModel = TravelModel()

    func testSetRemainingDistance_whenDistanceLessThanOrEqualToPerimeter_returnTrue() {
        let perimeter = 10.0
        let distance = perimeter * 1000.0
        travelModel.perimeter = perimeter
        notificationController.setTravelModel(travel: travelModel)

        let result = notificationController.setRemainingDistance(distance: distance)

        XCTAssertTrue(result)
    }

    func testSetRemainingDistance_whenDistanceLessThanOrEqualToPerimeter_returnFalse() {
        let perimeter = 10.0
        let distance = perimeter * 1000.0
        travelModel.perimeter = 1
        notificationController.setTravelModel(travel: travelModel)

        let result = notificationController.setRemainingDistance(distance: distance)

        XCTAssertFalse(result)
    }

    func testPeriodUpdate_whenRemainingTimeIsZero_returnTrue() {
        travelModel.remainingTime = 0.0
        notificationController.setTravelModel(travel: travelModel)

        let result = notificationController.periodUpdate()

        XCTAssertTrue(result)
        XCTAssertEqual(travelModel.alertCode, -2)
        XCTAssertTrue(travelModel.throwAlert)
    }
}
