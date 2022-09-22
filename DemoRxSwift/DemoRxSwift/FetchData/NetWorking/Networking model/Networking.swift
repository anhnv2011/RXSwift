//
//  Networking.swift
//  DemoRxSwift
//
//  Created by MAC on 8/3/22.
//

import Foundation
import RxSwift
class Networking {
    static let shared = Networking()
    enum URLLink {
        static let baseURL: URL? = URL(string: "https://www.thecocktaildb.com/api/json/v1/1/")
        case categories
        case drink
        var url: URL? {
            switch self {
            case .categories:
                return URLLink.baseURL?.appendingPathComponent("list.php")
            case .drink:
                return URLLink.baseURL?.appendingPathComponent("filter.php")
            }
        }
    }
    
    private init() { }
      
      // MARK: - Properties
      
      // MARK: - Process methods
      static func jsonDecoder(contentIdentifier: String) -> JSONDecoder {
          let decoder = JSONDecoder()
          decoder.userInfo[.contentIdentifier] = contentIdentifier
          decoder.dateDecodingStrategy = .iso8601
          return decoder
      }
      
      // MARK: - Request
    func request<T: Codable>(url: URL?, query: [String: Any] = [:], contentIdentifier: String = "") -> Observable<T> {
        do {
            // check URL == nil
            guard let URL = url,
                var components = URLComponents(url: URL, resolvingAgainstBaseURL: true) else {
                    throw NetworkingError.invalidURL(url?.absoluteString ?? "n/a")
            }
            
            // add param to String query
            components.queryItems = try query.compactMap { (key, value) in
                guard let v = value as? CustomStringConvertible else {
                    throw NetworkingError.invalidParameter(key, value)
                }
                return URLQueryItem(name: key, value: v.description)
            }
            
            // get final url
            guard let finalURL = components.url else {
                throw NetworkingError.invalidURL(url?.absoluteString ?? "n/a")
            }
            
            print("⚠️ url: \(finalURL.absoluteString)")
            let request = URLRequest(url: finalURL)
            
            // connect with urlrequest
            return URLSession.shared.rx.response(request: request)
                .map { (result: (response: HTTPURLResponse, data: Data)) -> T in
                    
                    if contentIdentifier != "" {
                        // Cách 1: với việc sử dụng `contentIdentifier` chính là key chính của array chúng ta cần lấy
                        // cách này rất chi là phức tạp cho anh em mình.
                        let decoder = Networking.jsonDecoder(contentIdentifier: contentIdentifier)
                        let envelope = try decoder.decode(NetworkingResult<T>.self, from: result.data)
                        return envelope.content

                    } else {
                        // Cách 2: Decode truyền thống với việc thiết kế `struct` cho Result
                        // đơn giản mà hiệu quả
                        let decoder = JSONDecoder()
                        return try! decoder.decode(T.self, from: result.data)
                    }
            }
        } catch {
            print(error.localizedDescription)
            return Observable.empty()
        }
    }
      
      // MARK: - Business
    
    func getCategories(kind: String) -> Observable<[CocktailCategory]>{
        let query: [String:Any] = [kind: "list"]
        let url = URLLink.categories.url
       
        // Dùng cách 1 ở trên request
        //let rq: Observable<[CocktailCategory]> = request(url: url, query: query, contentIdentifier: "drinks")
        
        // Dùng cách 2 ở trên request
        let rq: Observable<CategoryResult<CocktailCategory>> = request(url: url, query: query)
        
        return rq
            .map { $0.drinks }
            .catchAndReturn([])
            .share(replay: 1, scope: .forever)

    }
  
    func getDrinks(kind: String, value: String) -> Observable<[Drink]> {
        let query: [String: Any] = [kind : value]
        let url = URLLink.drink.url
        
        let rq: Observable<[Drink]> = request(url: url, query: query, contentIdentifier: "drinks")
        
        return rq.catchAndReturn([])
    }
}
