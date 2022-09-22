//
//  Weather.swift
//  WeatherRxSwift
//
//  Created by MAC on 8/17/22.
//

import Foundation
import CoreLocation

struct Weather: Decodable {
    let cityName: String
    let temperature: Int
    let humidity: Int
    let icon: String
    let coordinate: CLLocationCoordinate2D
    
    static let empty = Weather(
        cityName: "Unknown",
        temperature: -1000,
        humidity: 0,
        icon: iconNameToChar(icon: "e"),
        coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0)
    )
    
    static let dummy = Weather(
        cityName: "Fx Studio",
        temperature: 99,
        humidity: 99,
        icon: iconNameToChar(icon: "01d"),
        coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0)
    )
    
    init(cityName: String,
         temperature: Int,
         humidity: Int,
         icon: String,
         coordinate: CLLocationCoordinate2D) {
        self.cityName = cityName
        self.temperature = temperature
        self.humidity = humidity
        self.icon = icon
        self.coordinate = coordinate
    }
    
    init(from decoder: Decoder) throws {
        // Coding Keys
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        // CityName
        cityName = try values.decode(String.self, forKey: .cityName)
        
        let info = try values.decode([AdditionalInfo].self, forKey: .weather)
        // icon
        icon = iconNameToChar(icon: info.first?.icon ?? "")
        
        let mainInfo = try values.nestedContainer(keyedBy: MainKeys.self, forKey: .main)
        // temp
        temperature = Int(try mainInfo.decode(Double.self, forKey: .temp))
        // humidity
        humidity = try mainInfo.decode(Int.self, forKey: .humidity)
        
        
        let coordinate = try values.decode(Coordinate.self, forKey: .coordinate)
        // coord
        self.coordinate = CLLocationCoordinate2D(latitude: coordinate.lat, longitude: coordinate.lon)
    }
    
    enum CodingKeys: String, CodingKey {
        case cityName = "name"
        case main
        case weather
        case coordinate = "coord"
    }
    
    enum MainKeys: String, CodingKey {
        case temp
        case humidity
    }
    
    private struct AdditionalInfo: Decodable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }
    
    private struct Coordinate: Decodable {
      let lat: CLLocationDegrees
      let lon: CLLocationDegrees
    }

}
