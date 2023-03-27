//
//  SearchCityViewModel.swift
//  RxSwift-MVVM-C
//
//  Created by Nguyen Viet Anh on 3/9/23.
//

import Foundation
import RxCocoa
protocol SearchCityViewPresentable {
    typealias Input = (
        searchText: Driver<String>, ()
    )
    typealias Output = ()
    var input : SearchCityViewPresentable.Input { get }
    var output : SearchCityViewPresentable.Output { get }
}

class SearchCityViewModel: SearchCityViewPresentable {
    var input : SearchCityViewPresentable.Input
    var output : SearchCityViewPresentable.Output
    
    init(input: SearchCityViewPresentable.Input) {
        self.input = input
        self.output = SearchCityViewModel.output(input: self.input)
        
    }
    
}

extension SearchCityViewModel {
    static func output(input: SearchCityViewPresentable.Input) -> SearchCityViewPresentable.Output {
        return ()
    }
}
