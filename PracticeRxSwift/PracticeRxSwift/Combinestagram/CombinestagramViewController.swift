//
//  CombinestagramViewController.swift
//  PracticeRxSwift
//
//  Created by MAC on 8/17/22.
//

import UIKit
import RxAlamofire
import RxAlamofire
import RxSwift
import RxCocoa
import CoreLocation
import Alamofire
import SwiftyJSON
class CombinestagramViewController: UIViewController {

    let bag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()

//        let url = URL(string: "\(Constans.baseUrl)/3/trending/tv/day?api_key=\(Constans.ApiKey)")
//        print(url)
//        RxAlamofire.json(.get,
//             "http://api.openweathermap.org/data/2.5/weather?appid=cb63cfeb10e0487e9e95367ca934a0ab&q=London",
//             parameters: ["q": "London", "appid": "cb63cfeb10e0487e9e95367ca934a0ab"])
//            .map { json -> Weather in
//                let decoder = JSONDecoder()
//                let results = try? decoder.decode(Weather.self, from: json as! Data)
//                return results!
//            }
//          .subscribe(onNext: { print($0) })
//          .disposed(by: bag)

        
        
//        let response = RxAlamofire.request(.get, "http://api.openweathermap.org/data/2.5/weather?appid=cb63cfeb10e0487e9e95367ca934a0ab&q=London").responseJSON()

        
        
     let response =   RxAlamofire.requestData(.get, "http://api.openweathermap.org/data/2.5/weather?appid=cb63cfeb10e0487e9e95367ca934a0ab&q=London")
        .flatMap({ data -> Observable<Weather> in
            let responseTuple = data as? (HTTPURLResponse, Data)

                        guard let jsonData = responseTuple?.1 else {
                            throw NSError(
                                domain: "",
                                code: -1,
                                userInfo: [NSLocalizedDescriptionKey: "Could not decode object"]
                            )
                        }
                        
                        let decoder = JSONDecoder()
                        let object = try decoder.decode(Weather.self, from: jsonData)
                        
                        return Observable.just(object)
            
        })
//            .subscribe(onNext: { r, rjson in
////                print(rjson)
//               let json = JSON(rjson)
//                do {
//                    let r = try JSONDecoder().decode(Weather.self, from: rjson as! Data)
//                    print(r)
//                } catch {
//
//                }
//            })

        response.subscribe(onNext:{ element in
            print(element)
                
        })
        .disposed(by: bag)
                // Observable<String>.of("http://api.openweathermap.org/data/2.5/weather?appid=cb63cfeb10e0487e9e95367ca934a0ab&q=London")
//            .map { urlString -> URL in  //convert from string to Url
//                return URL(string: urlString)!
//            }
//            .map { url -> URLRequest in   // url -> urlrequest
//                let request = URLRequest(url: url)
//
//                // modified Header here
//
//                return request
//            }
//
//            .flatMap { request -> Observable<(response: HTTPURLResponse, data: Data)> in
//                return URLSession.shared.rx.response(request: request)
//            }
//
//
//            .share(replay: 1)
//
//
//
//
//        // subscription #1
//        response
//            .filter { response, _ -> Bool in
//                return 200..<300 ~= response.statusCode
//            }
//            .map { _, data -> Weather in
//                let decoder = JSONDecoder()
//                let results = try? decoder.decode(Weather.self, from: data)
//                return results!
//            }
////            .filter { objects in
////                return objects != nil
////            }
//            .subscribe(onNext: { location in
//                print(location)
//            })
//            .disposed(by: bag)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
struct Music: Codable {
    var artistName: String?
    var id: String?
    var releaseDate: String?
    var name: String?
    var copyright: String?
    var artworkUrl100: String?
}

struct MusicResults: Codable {
  var results: [Music]
}

struct FeedResult: Codable {
  var feed: MusicResults
}
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
public func iconNameToChar(icon: String) -> String {
  switch icon {
  case "01d":
    return  "☀️"
  case "01n":
    return "🌙"
  case "02d":
    return "🌤"
  case "02n":
    return "🌤"
  case "03d", "03n":
    return "☁️"
  case "04d", "04n":
    return "☁️"
  case "09d", "09n":
    return "🌧"
  case "10d", "10n":
    return "🌦"
  case "11d", "11n":
    return "⛈"
  case "13d", "13n":
    return "❄️"
  case "50d", "50n":
    return "💨"
  default:
    return "E"
  }
}
extension CLLocation: Encodable {
    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
        case altitude
        case horizontalAccuracy
        case verticalAccuracy
        case speed
        case course
        case timestamp
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(coordinate.latitude, forKey: .latitude)
        try container.encode(coordinate.longitude, forKey: .longitude)
        try container.encode(altitude, forKey: .altitude)
        try container.encode(horizontalAccuracy, forKey: .horizontalAccuracy)
        try container.encode(verticalAccuracy, forKey: .verticalAccuracy)
        try container.encode(speed, forKey: .speed)
        try container.encode(course, forKey: .course)
        try container.encode(timestamp, forKey: .timestamp)
    }
}
