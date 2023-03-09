//
//  FlightData.swift
//  wakeUpThere
//
//  Created by Daniel Košč on 14/07/2022.
//

import Foundation

/// Singleton Model to represent flight data received by API
class FlightData {

    static let instance = FlightData()

    private var flightNumber: String = ""
    private var data: APIResult?
    private var estimatedArrivalTimeStamp: Int = 0
    private var scheaduledArrivalTimeStamp: Int = 0
    private var timeZone: String = TimeZone.current.identifier
    private var errCode: Int = -10

    /// Getter of error codes
    /// - Returns: Integer error code value
    public func getErr() -> Int {
        return errCode
    }

    /// Select the next arriving flight with the entered flight number
    /// - Parameter flightNumber: String representation of flight number
    public func setFlightNumber(flightNumber: String) {
        self.flightNumber = flightNumber
        self.getData(completion: {errorCode in
            self.errCode = errorCode
            if errorCode != 0 {
                return
            } else {
                self.extractEstimatedTime()
            }
        })
    }

    /// Load expected arrival time from API data respons.
    public func extractEstimatedTime() {
        if let myFlight = self.getNextFlight() {
            if let arivalScheduledTime = myFlight.time.scheduled.arrival {
                self.scheaduledArrivalTimeStamp = arivalScheduledTime
            }
            if let arivalEstimatedTime = myFlight.time.estimated.arrival {
                self.estimatedArrivalTimeStamp = arivalEstimatedTime
            }
        } else {
            self.errCode = 4
        }
    }

    /// Is arrival closer than selected amount of seconds from now
    /// - Parameter seconds: number of seconds
    /// - Returns: Boolean comparation result
    public func isCloaserThan(seconds: Int) -> Bool {
        if estimatedArrivalTimeStamp != 0 {
            return true
        } else if scheaduledArrivalTimeStamp <= seconds + Int(Date().timeIntervalSince1970) {
            return true
        }
        return false
    }

    /// Getter function get get expected arrival
    /// - Returns: timestamp as Integer value
    public func getExpectedArrivalTimestamp() -> Int {
        if estimatedArrivalTimeStamp != 0 {
           return estimatedArrivalTimeStamp
        } else if scheaduledArrivalTimeStamp != 0 {
            return scheaduledArrivalTimeStamp
        }
        return 0
    }

    /// Get most acurat arrival time converted to local timezone and start periodic check
    /// - Returns: NSDate arrival time
    public func getArrivalDate() -> NSDate {
        let arrivalTimestamp = getExpectedArrivalTimestamp()
        NotificationController.instance.startPeriodicalUpdate(arrival: Double(arrivalTimestamp))
        return convertTime(timeStamp: arrivalTimestamp)
    }

    /// Get estimated arrival time
    /// - Returns: NSDate arrival time
    public func getEstimatedArrival() -> NSDate {
        return convertTime(timeStamp: scheaduledArrivalTimeStamp)
    }

    /// Get scheduled arrival time
    /// - Returns: NSDate arrival time
    public func getScheaduledArrival() -> NSDate {
        return convertTime(timeStamp: scheaduledArrivalTimeStamp)
    }

    /// Convert Timestamp to NSDate using current timezone
    /// - Parameter timeStamp: timestamp to convert
    /// - Returns: NSDate in current timezone
    private func convertTime(timeStamp: Int) -> NSDate {
        let tempTimeInterval = TimeInterval(timeStamp)
        let GMTdate = Date(timeIntervalSince1970: TimeInterval(tempTimeInterval))

        let GMTdateFormater: DateFormatter = DateFormatter()
        GMTdateFormater.timeZone = TimeZone(identifier: self.timeZone) // convert to this timezone
        GMTdateFormater.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let localDateFormater = DateFormatter()
        localDateFormater.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let tempString = GMTdateFormater.string(from: GMTdate)

        if let localArrivalDate = localDateFormater.date(from: tempString) {
            return localArrivalDate as NSDate
        }
        return NSDate(timeIntervalSince1970: 0)
    }

    /// Find first arriving flight with that flight number in the future
    /// - Returns: Flight instance
    private func getNextFlight() -> Flight? {
        let currentTime = NSDate().timeIntervalSince1970
        var nextFlight: Flight?
        if let data = self.data {
            for flight in data.result.response.data {
                if let arrival = flight.time.scheduled.arrival {
                    if TimeInterval(arrival) > currentTime {
                        nextFlight = flight
                    }
                }
                if let arrival = flight.time.estimated.arrival {
                    if TimeInterval(arrival) > currentTime {
                        nextFlight = flight
                    }
                }
            }
        }
        return nextFlight
    }

    /// Call API to get all flight data about the flight with previously selected flight number
    /// - Parameter completion: trigger called after recieving the data
    public func getData(completion: @escaping ((Int) -> Void)) {
        let headers = [
            "X-RapidAPI-Key": Constants.flightRadarAPIKey,
            "X-RapidAPI-Host": "flight-radar1.p.rapidapi.com"
        ]

        let url = "https://flight-radar1.p.rapidapi.com/flights/get-more-info?query=\(self.flightNumber)&fetchBy=flight&page=1&limit=100"

        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, _, _) -> Void in
            guard let data = data else {
                completion(3)
                return
            }
            guard let flightData = try? JSONDecoder().decode(APIResult.self, from: data) else {
                completion(1)
                return
            }

            self.data = flightData
            completion(0)
        })
        dataTask.resume()
    }

    public static func flightNumberCheck(flightNumber: String) -> Bool {
        if flightNumber.count < 3 || flightNumber.count > 6 {
            return false
        }

        let firstLetter = flightNumber[flightNumber.startIndex]
        let secondLetter = flightNumber[flightNumber.index(flightNumber.startIndex, offsetBy: 1)]

        if !(firstLetter.isLetter || secondLetter.isLetter) {
            return false
        }
        for character in flightNumber[flightNumber.index(flightNumber.startIndex, offsetBy: 2)...flightNumber.index(before: flightNumber.endIndex)] {
            if !character.isNumber {
                return false
            }
        }

        return true
    }

    public func resetData() {
        flightNumber = ""
        data = nil
        estimatedArrivalTimeStamp = 0
        scheaduledArrivalTimeStamp = 0
        timeZone = TimeZone.current.identifier
        errCode = -10
    }
}
