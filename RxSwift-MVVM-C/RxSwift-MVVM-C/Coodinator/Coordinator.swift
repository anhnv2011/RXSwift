//
//  Coordinator.swift
//  RxSwift-MVVM-C
//
//  Created by Nguyen Viet Anh on 3/13/23.
//

import Foundation

protocol Coordinator: class {
    var childCoordinator: [Coordinator] { get set }
    func start()
}

extension Coordinator {
    func add(coordinator: Coordinator) -> Void {
        childCoordinator.append(coordinator)
    }
    func remove(coordinator: Coordinator) -> Void {
        childCoordinator = childCoordinator.filter({$0 !== coordinator})
    }
}
