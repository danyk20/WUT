//
//  LocationServise.swift
//  wakeUpThere
//
//  Created by Daniel Košč on 12/06/2022.
//

import Foundation
import MapKit

/// Struct to be filled with Positionstack JSON data response.
struct PositionstackResponse: Codable {
    let data: [Location]
}

/// Helper struct to store data necessary for suggestions and pin on the map.
struct Location: Codable, Hashable, Identifiable {
    let id = UUID()
    let latitude, longitude: Double
    let name, countryCode, region: String

    // only these attributes will be decoded from the JSON
    enum CodingKeys: String, CodingKey {
        case latitude = "latitude"
        case longitude = "longitude"
        case name = "name"
        case countryCode = "country_code"
        case region = "region"
        }

    init(latitude: Double, longitude: Double, name: String, countryCode: String = "", region: String = "") {
        self.longitude = longitude
        self.latitude = latitude
        self.name = name
        self.countryCode = countryCode
        self.region = region
    }

    init(location2D: CLLocationCoordinate2D) {
        self.longitude = location2D.longitude
        self.latitude = location2D.latitude
        self.name = ""
        self.countryCode = ""
        self.region = ""
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(latitude)
        hasher.combine(longitude)
        hasher.combine(name)
        hasher.combine(region)
    }

    /// Convert latitude and longitude attributes to CLLocationCoordinate2D instance.
    /// - Returns: CLLocationCoordinate2D instance of selected Location
    public func getCoordinates2D() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

/// Singleton class dealing with pin-mark on the map using Positionstack API.
class MapAPI: ObservableObject {

    static let instance = MapAPI()

    private static let baseURL = "http://api.positionstack.com/v1/forward"
    private static let reverseURL = "http://api.positionstack.com/v1/reverse"
    private static let apiKey = Constants.positionstackAPIKey

    @Published var locations: [Location] = []

    /// Get all possible suggestions based on entered address.
    /// - Parameters:
    ///   - address: address represented as a String
    ///   - completion: value containing all suggestions as a Location array that will be returned after function is finished
    public func getPossiblePlaces(address: String, completion: @escaping (([Location]) -> Void)) {
        let pAddress = address.replacingOccurrences(of: " ", with: "%20")
        let urlString = "\(MapAPI.baseURL)?access_key=\(MapAPI.apiKey)&query=\(pAddress)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard let data = data else {
                print(error?.localizedDescription ?? "Error Occured while requesting data from API!")
                return
            }
            guard let newCoordinates = try? JSONDecoder().decode(PositionstackResponse.self, from: data) else {return}
            if newCoordinates.data.isEmpty {
                print("Could not find the address...")
                return
            }
            self.setDestination(selectedLocation: newCoordinates.data[0])
            completion(newCoordinates.data)
        }.resume()
    }

    public func getPositionFromCoordinates(coordinates: CLLocationCoordinate2D, completion: @escaping (([Location]) -> Void)) {
        let query = "\(coordinates.latitude),\(coordinates.longitude)"
        let urlString = "\(MapAPI.reverseURL)?access_key=\(MapAPI.apiKey)&query=\(query)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard let data = data else {
                print(error?.localizedDescription ?? "Error Occured while requesting data from API!")
                return
            }
            guard let newCoordinates = try? JSONDecoder().decode(PositionstackResponse.self, from: data) else {return}
            if newCoordinates.data.isEmpty {
                print("Could not find the address...")
                return
            }
            self.setDestination(selectedLocation: newCoordinates.data[0])
            completion(newCoordinates.data)
        }.resume()
    }

    /// Get air distance from a selected destination in location array and current location.
    /// - Parameter startLocation: current user's coordinates
    /// - Returns: distance in meters
    public func getRemainingDistance(startLocation: CLLocationCoordinate2D? = PositionLocator.getCurrentLocation()) -> Double {
        if locations.isEmpty {
            return Double.infinity
        }
        guard let startLocation = startLocation else {
            return Double.infinity
        }

        let currentPosition = MKMapPoint(startLocation)
        let destinationPosition = MKMapPoint(locations[0].getCoordinates2D())
        return currentPosition.distance(to: destinationPosition)
    }

    /// Add selected place to locations array for pin-mark on the map.
    /// - Parameter selectedLocation: place represented as Location instance, in case of nil pin-mark will not be shown
    public func setDestination(selectedLocation: Location?) {
            DispatchQueue.main.async {
                self.locations.removeAll()
                if let selectedLocation = selectedLocation {
                    self.locations.insert(Location(latitude: selectedLocation.latitude,
                                                   longitude: selectedLocation.longitude,
                                                   name: selectedLocation.name,
                                                   region: selectedLocation.region), at: 0)
                }
            }
    }
}
