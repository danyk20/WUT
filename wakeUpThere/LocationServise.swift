//
//  LocationServise.swift
//  wakeUpThere
//
//  Created by Daniel Košč on 12/06/2022.
//

import Foundation
import MapKit

struct Address: Codable{
    let data: [Datum]
}

struct Datum: Codable, Hashable{
    let latitude, longitude: Double
    let name : String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(latitude)
        hasher.combine(longitude)
    }
}

struct Location: Identifiable{
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

class MapAPI: ObservableObject{
    private let BASE_URL = "http://api.positionstack.com/v1/forward"
    private let API_KEY = "268d3f7afcbf9cbc398559f20b456ca1"
    
    @Published var region: MKCoordinateRegion
    @Published var coordinates = []
    @Published var locations: [Location] = []
    
    init() {
        self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51, longitude: 0), latitudinalMeters: 10000, longitudinalMeters: 10000)
        
        self.locations.insert(Location(name: "Pin", coordinate: CLLocationCoordinate2D(latitude: 51, longitude: 0)), at: 0)
    }
    
    func getPossiblePlaces(address: String, delta: Double, completion: @escaping (([Datum]) -> Void)){
        let pAddress = address.replacingOccurrences(of: " ", with: "%20")
        let url_string = "\(BASE_URL)?access_key=\(API_KEY)&query=\(pAddress)"
        guard let url = URL(string: url_string) else{
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                print(error!.localizedDescription)
                return
            }
            guard let newCoordinates = try? JSONDecoder().decode(Address.self, from: data) else {return}
            
            if newCoordinates.data.isEmpty{
                print("Could not find the address...")
                return
            }
                self.getLocation(selectedLocation: newCoordinates.data[0], delta: delta)
                completion(newCoordinates.data)
        }.resume()
    }
    
    
    func getLocation(selectedLocation: Datum, delta: Double){
            DispatchQueue.main.async {
                let details = selectedLocation
                let lat = details.latitude
                let lon = details.longitude
                let name = details.name
                
                self.coordinates = [lat, lon]
                self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: lon), latitudinalMeters: delta, longitudinalMeters: delta)
                
                let new_location = Location(name: name, coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon))
                self.locations.removeAll()
                self.locations.insert(new_location, at: 0)
                
                print("Sucessfull")
            }
    }
}

