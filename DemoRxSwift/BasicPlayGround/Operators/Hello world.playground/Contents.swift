import UIKit
import RxSwift
import RxCocoa

example(of: "Hello Operator") {
    let bag = DisposeBag()
    
    let hello = Observable.from(["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"])
    
    //subcribe 1
    hello
        //        .reduce("", accumulator: +)
        .reduce("", accumulator: { result, value in
            return result + value
        })
        .subscribe(onNext: { value in
            print("after reduce", value)
        }, onError: { error in
            print(error)
        }, onCompleted: {
            print("Completed")
        }) {
            print("Disposed")
        }
        .disposed(by: bag)
    //
    //    after reduce 0123456789
    //    Completed
    //    Disposed
    
    //subcribe 2
    hello
        .scan("", accumulator: +)
        .subscribe(onNext: { value in
            print("after scan", value)
        }, onError: { error in
            print(error)
        }, onCompleted: {
            print("Completed")
        }) {
            print("Disposed")
        }
        .disposed(by: bag)
}
//after scan 0
//after scan 01
//after scan 012
//after scan 0123
//after scan 01234
//after scan 012345
//after scan 0123456
//after scan 01234567
//after scan 012345678
//after scan 0123456789
//Completed
//Disposed


example(of: "map") {
    let bag = DisposeBag()
    
    let hello = Observable.from(["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"])
    
    //subcribe 1
    hello
        .map({Int($0)})
        .subscribe(onNext: { value in
            print("map:", value!)
        }, onError: { error in
            print(error)
        }, onCompleted: {
            print("Completed")
        }) {
            print("Disposed")
        }
        .disposed(by: bag)
}


example(of: "map + filter") {
    let bag = DisposeBag()
    
    let hello = Observable.from(["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"])
    
    //subcribe 1
    hello
        .map({Int($0) ?? 0})
        .filter({ $0 % 2 == 0})
        .subscribe(onNext: { value in
            print("map + filter:", value)
        }, onError: { error in
            print(error)
        }, onCompleted: {
            print("Completed")
        }) {
            print("Disposed")
        }
        .disposed(by: bag)
}
