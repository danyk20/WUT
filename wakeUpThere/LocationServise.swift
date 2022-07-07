//
//  LocationServise.swift
//  wakeUpThere
//
//  Created by Daniel Košč on 12/06/2022.
//

import Foundation
import MapKit

/// Struct to be filled with Positionstack JSON data response.
struct PositionstackResponse: Codable{
    let data: [Location]
}

/// Helper struct to store data necessary for suggestions and pin on the map.
struct Location: Codable, Hashable, Identifiable{
    let id = UUID()
    let latitude, longitude: Double
    let name, countryCode : String
    
    // only these attributes will be decoded from the JSON
    enum CodingKeys: String, CodingKey {
        case latitude = "latitude"
        case longitude = "longitude"
        case name = "name"
        case countryCode = "country_code"
        }
    
    init(latitude: Double, longitude: Double, name: String, countryCode: String = ""){
        self.longitude = longitude
        self.latitude = latitude
        self.name = name
        self.countryCode = countryCode
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(latitude)
        hasher.combine(longitude)
        hasher.combine(name)
    }
    
    /// Convert latitude and longitude attributes to CLLocationCoordinate2D instance.
    /// - Returns: CLLocationCoordinate2D instance of selected Location
    func getCoordinates2D() -> CLLocationCoordinate2D{
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

/// Class dealing with pin-mark on the map using Positionstack API.
class MapAPI: ObservableObject{
    private let baseURL = "http://api.positionstack.com/v1/forward"
    private let apiKey = "268d3f7afcbf9cbc398559f20b456ca1"
    private let initMapCenter = CLLocationCoordinate2D(latitude: 51, longitude: 0)
    private let initZoom: Double = 1000
    
    @Published var region: MKCoordinateRegion
    @Published var coordinates = []
    @Published var locations: [Location] = []
    
    init() {
        self.region = MKCoordinateRegion(center: initMapCenter, latitudinalMeters: initZoom, longitudinalMeters: initZoom)
    }
    
    /// Get all possible suggestions based on entered address.
    /// - Parameters:
    ///   - address: address represented as a String
    ///   - completion: value containing all suggestions as a Location array that will be returned after function is finished
    func getPossiblePlaces(address: String, completion: @escaping (([Location]) -> Void)){
        let pAddress = address.replacingOccurrences(of: " ", with: "%20")
        let url_string = "\(baseURL)?access_key=\(apiKey)&query=\(pAddress)"
        guard let url = URL(string: url_string) else{
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                print(error!.localizedDescription)
                return
            }
            guard let newCoordinates = try? JSONDecoder().decode(PositionstackResponse.self, from: data) else {return}
            if newCoordinates.data.isEmpty{
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
    func getRemainingDistance(startLocation: CLLocationCoordinate2D) -> Double{
        if locations.isEmpty{
            return Double.infinity
        }
        let currentPosition = MKMapPoint(startLocation)
        let destinationPosition = MKMapPoint(locations[0].getCoordinates2D())
        return currentPosition.distance(to: destinationPosition)
    }
    
    
    /// Add selected place to locations array for pin-mark on the map.
    /// - Parameter selectedLocation: place represented as Location instance
    func setDestination(selectedLocation: Location){
            DispatchQueue.main.async {
                let lat = selectedLocation.latitude
                let lon = selectedLocation.longitude
                let name = selectedLocation.name
                
                self.coordinates = [lat, lon]
                //self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: lon), latitudinalMeters: delta, longitudinalMeters: delta) center map based on selectedLocation
                
                self.locations.removeAll()
                self.locations.insert(Location(latitude: lat, longitude: lon, name: name), at: 0)
                
                print("Sucessfuly founded location")
            }
    }
}
