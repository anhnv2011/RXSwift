//
//  Drink.swift
//  DemoRxSwift
//
//  Created by MAC on 8/3/22.
//

import Foundation
//thecocktaildb.com/api/json/v1/1/filter.php?c=Cocktail

struct DrinkResult {
    var drinks: [Drink]
}
struct Drink: Codable {
    var strDrink: String
    var strDrinkThumb: String
    var idDrink: String
}

