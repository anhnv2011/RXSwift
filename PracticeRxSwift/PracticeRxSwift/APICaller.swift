//
//  APICaller.swift
//  PracticeRxSwift
//
//  Created by MAC on 8/17/22.
//

import Foundation
import RxAlamofire
import RxSwift
import RxCocoa
import SwiftyJSON
struct Constans {
    static let ApiKey = "dc7bb41154658ee8cd23ecf49d7203c2"
    static let baseUrl = "https://api.themoviedb.org/"
}
class APICaller {
    static let share = APICaller()
 
    func getTrending (mediaType: String, time:String, completion: @escaping (Result<[Film], Error>) -> Void){
        guard let url = URL(string: "\(Constans.baseUrl)3/trending/\(mediaType)/\(time)?api_key=\(Constans.ApiKey)") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { (data, response, error) in
            guard let data = data,
                  error == nil else {return}
            do {
                //let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                let result = try JSONDecoder().decode(Trending.self, from: data)
                completion(.success(result.results))
                //print(result)
            } catch {
                completion(.failure(error))
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
//    func getdata() -> Observable<Film> {
////        let url = "https://itunes.apple.com/search?"
////        let parameters: Parameters = [
////            "term" : "\(searchString)",
////            "limit": "10"
////        ]
////        Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.queryString, headers: nil).responseJSON(completionHandler: { (response) in
////            guard let value = response.result.value else {
////                return
////            }
//////            let success = response.result.
//////            switch success {
//////            case .success(let success)
//////                print("success")
//////            case .failure(let error):
//////                print(error.localizedDescription)
//////            }
////            self.dataSearch = Itunes(JSON(value)).results!
////
////
////        })
////
////        guard let url = URL(string: "\(Constans.baseURL)/3/trending/tv/day?api_key=\(Constants.API_KEY)") else {return}
//        let url = URL(string: "\(Constans.baseUrl)/3/trending/tv/day?api_key=\(Constans.ApiKey)")
//        return Observable.create({ observer in
//            RxAlamofire.request(URLRequest(url: url)).res
//
//            return Disposables.create({
//
//            })
//        })
//    }
}
struct Trending: Codable {
    let results: [Film]
}
struct Film:Codable {
    let adult:Bool
    let id: Int
    let media_type: String?
    let title: String?
    let original_name: String?
    let original_language: String?
    let original_title: String?
    let overview: String?
    let popularity:Double?
    let poster_path: String
    let release_date: String?
    let video: Bool?
    let vote_average: Double
    let vote_count: Int


}
struct Itunes {

    let resultCount: Int?
    let results: [Results]?

    init(_ json: JSON) {
        resultCount = json["resultCount"].intValue
        results = json["results"].arrayValue.map { Results($0) }
    }

}
struct Results {

    let wrapperType: String?
    let kind: String?
    let collectionId: Int?
    let trackId: Int?
    let artistName: String?
    let collectionName: String?
    let trackName: String?
    let collectionCensoredName: String?
    let trackCensoredName: String?
    let collectionArtistId: Int?
    let collectionArtistViewUrl: String?
    let collectionViewUrl: String?
    let trackViewUrl: String?
    let previewUrl: String?
    let artworkUrl30: String?
    let artworkUrl60: String?
    let artworkUrl100: String?
    let collectionPrice: Double?
    let trackPrice: Double?
    let trackRentalPrice: Double?
    let collectionHdPrice: Double?
    let trackHdPrice: Double?
    let trackHdRentalPrice: Double?
    let releaseDate: String?
    let collectionExplicitness: String?
    let trackExplicitness: String?
    let discCount: Int?
    let discNumber: Int?
    let trackCount: Int?
    let trackNumber: Int?
    let trackTimeMillis: Int?
    let country: String?
    let currency: String?
    let primaryGenreName: String?
    let contentAdvisoryRating: String?
    let longDescription: String?
    let hasITunesExtras: Bool?

    init(_ json: JSON) {
        wrapperType = json["wrapperType"].stringValue
        kind = json["kind"].stringValue
        collectionId = json["collectionId"].intValue
        trackId = json["trackId"].intValue
        artistName = json["artistName"].stringValue
        collectionName = json["collectionName"].stringValue
        trackName = json["trackName"].stringValue
        collectionCensoredName = json["collectionCensoredName"].stringValue
        trackCensoredName = json["trackCensoredName"].stringValue
        collectionArtistId = json["collectionArtistId"].intValue
        collectionArtistViewUrl = json["collectionArtistViewUrl"].stringValue
        collectionViewUrl = json["collectionViewUrl"].stringValue
        trackViewUrl = json["trackViewUrl"].stringValue
        previewUrl = json["previewUrl"].stringValue
        artworkUrl30 = json["artworkUrl30"].stringValue
        artworkUrl60 = json["artworkUrl60"].stringValue
        artworkUrl100 = json["artworkUrl100"].stringValue
        collectionPrice = json["collectionPrice"].doubleValue
        trackPrice = json["trackPrice"].doubleValue
        trackRentalPrice = json["trackRentalPrice"].doubleValue
        collectionHdPrice = json["collectionHdPrice"].doubleValue
        trackHdPrice = json["trackHdPrice"].doubleValue
        trackHdRentalPrice = json["trackHdRentalPrice"].doubleValue
        releaseDate = json["releaseDate"].stringValue
        collectionExplicitness = json["collectionExplicitness"].stringValue
        trackExplicitness = json["trackExplicitness"].stringValue
        discCount = json["discCount"].intValue
        discNumber = json["discNumber"].intValue
        trackCount = json["trackCount"].intValue
        trackNumber = json["trackNumber"].intValue
        trackTimeMillis = json["trackTimeMillis"].intValue
        country = json["country"].stringValue
        currency = json["currency"].stringValue
        primaryGenreName = json["primaryGenreName"].stringValue
        contentAdvisoryRating = json["contentAdvisoryRating"].stringValue
        longDescription = json["longDescription"].stringValue
        hasITunesExtras = json["hasITunesExtras"].boolValue
    }

}
