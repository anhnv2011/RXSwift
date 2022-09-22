//
//  AnimalSection.swift
//  DemoRxTableView
//
//  Created by MAC on 8/25/22.
//

import Foundation
import RxSwift
import RxDataSources
struct AnimalSection {
    var header: String
    var items: [Animal]
}

extension AnimalSection: SectionModelType {
  
    
    init(original: AnimalSection, items: [Animal]) {
        self = original
        self.items = items
    }
}
