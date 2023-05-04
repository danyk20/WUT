//
//  SoundManagerTests.swift
//  wakeUpThereTests
//
//  Created by Oliver Rainoch on 19.03.2023.
//

import Foundation
import XCTest

@testable import wakeUpThere

class FlightDataTests: XCTestCase {

    let flightData = FlightData()

    func testFlightNumberCheck_validFlightNumber_returnsTrue() {
        let validFlightNumber = "AB123"

        let result = FlightData.flightNumberCheck(flightNumber: validFlightNumber)

        XCTAssertTrue(result)
    }

    func testFlightNumberCheck_shortFlightNumber_returnsFalse() {
        let shortFlightNumber = "AB"

        let result = FlightData.flightNumberCheck(flightNumber: shortFlightNumber)

        XCTAssertFalse(result)
    }

    func testFlightNumberCheck_longFlightNumber_returnsFalse() {
        let longFlightNumber = "AB1234567"

        let result = FlightData.flightNumberCheck(flightNumber: longFlightNumber)

        XCTAssertFalse(result)
    }

    func testFlightNumberCheck_flightNumberWithValidFirstLetter_returnsFalse() {
        let invalidFirstLetter = "1B123"

        let result = FlightData.flightNumberCheck(flightNumber: invalidFirstLetter)

        XCTAssertTrue(result)
    }

    func testFlightNumberCheck_flightNumberWithValidSecondLetter_returnsFalse() {
        let invalidSecondLetter = "A9123"

        let result = FlightData.flightNumberCheck(flightNumber: invalidSecondLetter)

        XCTAssertTrue(result)
    }

    func testFlightNumberCheck_flightNumberWithInvalidCharacters_returnsFalse() {
        let invalidCharacters = "AB12C"

        let result = FlightData.flightNumberCheck(flightNumber: invalidCharacters)

        XCTAssertFalse(result)
    }

    func testFlightNumberCheck_flightNumberWithNilCharacters_returnsFalse() {
        let invalidCharacters = ""

        let result = FlightData.flightNumberCheck(flightNumber: invalidCharacters)

        XCTAssertFalse(result)
    }

    func testFlightNumberCheck_flightNumberWithTooManyCharacters_returnsFalse() {
        let invalidCharacters = "AAAAAAAA"

        let result = FlightData.flightNumberCheck(flightNumber: invalidCharacters)

        XCTAssertFalse(result)
    }
}
