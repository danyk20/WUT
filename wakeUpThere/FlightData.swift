//
//  FlightData.swift
//  wakeUpThere
//
//  Created by Daniel Košč on 14/07/2022.
//

import Foundation

struct TimeData: Codable{
    let departure: Int?
    let arrival: Int?
}

struct FlightTime: Codable{
    let scheduled: TimeData
//    let real: TimeData
    let estimated: TimeData
   // let other: String
}

struct Flight: Codable{
    //let identification: String
    //let status: String
    //let aircraft: String
    //let owner: String
    //let airline: String
    let time: FlightTime
}

struct FlightInfo: Codable{
    // let item: String
    //let page: String
    let timestamp: Int
    let data: [Flight]
    //let aircraftInfo: String
    // let aircraftImages
}

struct FlightRequest: Codable{
    //let request: String
    let response: FlightInfo
}

struct APIResult: Codable{
    let result: FlightRequest
}

/// Singleton Model to represent flight data recieved by API
class FlightData{
    
    static let instance = FlightData()
    
    private var flightNumber: String = ""
    private var data: APIResult?
    private var estimatedArrivalTimeStamp = 0
    private var scheaduledArrivalTimeStamp: Int = 0
    private var timeZone: String = TimeZone.current.identifier
    private let url: String = "https://flightaware.com/live/flight/"
    private var problem: Bool = false
    
    /// Chceck if there occure any error
    /// - Returns: Boolean value if error occure
    public func isProblem() ->Bool{
        return problem
    }
    
    /// Select the next arriving flight with the entered flight number
    /// - Parameter flightNumber: String representation of flight number
    public func setFlightNumber(flightNumber: String){
        self.flightNumber = flightNumber
        self.getData {
            if let myFlight = self.getNextFlight(){
                if let arivalScheduledTime = myFlight.time.scheduled.arrival{
                    self.scheaduledArrivalTimeStamp = arivalScheduledTime
                }
                if let arivalEstimatedTime = myFlight.time.estimated.arrival{
                    self.estimatedArrivalTimeStamp = arivalEstimatedTime
                }
            }
        }
    }
    
    /// Is arrival closer than selected amount of seconds from now
    /// - Parameter seconds: number of seconds
    /// - Returns: Boolean comparation result
    public func isCloaserThan(seconds: Int) -> Bool{
        if estimatedArrivalTimeStamp != 0{
            return true
        }else if scheaduledArrivalTimeStamp <= seconds + Int(Date().timeIntervalSince1970){
            return true
        }
        return false
    }
    
    /// Get most acurat arrival time
    /// - Returns: NSDate arrival time
    public func getArrivalTime() -> NSDate{
        if estimatedArrivalTimeStamp != 0{
            return convertTime(timeStamp: estimatedArrivalTimeStamp)
        }else if scheaduledArrivalTimeStamp != 0{
            return convertTime(timeStamp: scheaduledArrivalTimeStamp)
        }
        return NSDate(timeIntervalSince1970: 0)
    }
    
    /// Get estimated arrival time
    /// - Returns: NSDate arrival time
    public func getEstimatedArrival() -> NSDate{
        return convertTime(timeStamp: scheaduledArrivalTimeStamp)
    }
    
    /// Get scheduled arrival time
    /// - Returns: NSDate arrival time
    public func getScheaduledArrival() -> NSDate{
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
        
        if let localArrivalDate = localDateFormater.date(from: tempString){
            return localArrivalDate as NSDate
        }
        return NSDate(timeIntervalSince1970: 0)
    }
    
    /// Find first arriving flight with that flight number in the future
    /// - Returns: Flight instance
    private func getNextFlight() -> Flight?{
        let currentTime = NSDate().timeIntervalSince1970
        var nextFlight: Flight?
        if let data = self.data {
            for flight in data.result.response.data{
                if let arrival = flight.time.scheduled.arrival{
                    if TimeInterval(arrival) > currentTime{
                        nextFlight = flight
                    }
                }
            }
        }
        return nextFlight
    }
    
    /// Call API to get all flight data about the flight with previously selected flight number
    /// - Parameter completion: trigger called after recieving the data
    private func getData(completion: @escaping (() -> Void)){
        if flightNumber == ""{
            return
        }
        let headers = [
            "X-RapidAPI-Key": "4e879a6157msh8d3d1a4c002c00ep14db1ejsn495a0bed8861",
            "X-RapidAPI-Host": "flight-radar1.p.rapidapi.com"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://flight-radar1.p.rapidapi.com/flights/get-more-info?query=\(self.flightNumber)&fetchBy=flight&page=1&limit=100")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            guard let data = data else {
                return
            }
            guard let flightData = try? JSONDecoder().decode(APIResult.self, from: data) else {return}
            
            self.data = flightData
            
            completion()
        })
        dataTask.resume()
    }
}
