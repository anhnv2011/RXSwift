//
//  BaseCoordinator.swift
//  RxSwift-MVVM-C
//
//  Created by Nguyen Viet Anh on 3/13/23.
//

import Foundation

class BaseCoordinator: Coordinator {
    var childCoordinator: [Coordinator] = []
    
    func start() {
        fatalError("Childrent should implement 'start'")
    }
    
    
}
