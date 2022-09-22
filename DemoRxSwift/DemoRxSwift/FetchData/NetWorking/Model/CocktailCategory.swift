//
//  CocktailCategory.swift
//  DemoRxSwift
//
//  Created by MAC on 8/3/22.
//

import Foundation
//https://www.thecocktaildb.com/api/json/v1/1/list.php?c=list

//MARK:- Mặc định sẽ làm thế này với 1
//struct CocktailCategory: Codable {
//
//    var drinks: [Drinks]
//
//    private enum CodingKeys: String, CodingKey {
//        case drinks = "drinks"
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        drinks = try values.decode([Drinks].self, forKey: .drinks)
//    }
//
//}
//struct Drinks: Codable {
//
//    var strCategory: String
//
//    private enum CodingKeys: String, CodingKey {
//        case strCategory = "strCategory"
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        strCategory = try values.decode(String.self, forKey: .strCategory)
//    }
//
//}

//MARK:- nhưng ta có thể làm như sau
struct CocktailCategory:Codable {
    var strCategory: String
    var items = [Drink]()
        
        private enum CodingKeys: String, CodingKey {
          case strCategory
        }
    
    /*items là một property tự  thêm vào. Nó không có trong JSON, nên khi decode thì sẽ bị lỗi. Vì vậy, bạn cần có thêm CodingKeys
     Với CodingKeys thì các case sẽ chỉ định việc map dữ liệu từ JSON sang CocktailCategory
     */
}
struct CategoryResult<T: Codable> : Codable {
    var drinks: [T]
}
