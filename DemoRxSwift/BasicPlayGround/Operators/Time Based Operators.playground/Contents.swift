import UIKit
import RxSwift
import RxCocoa
//https://fxstudio.dev/rxswift-time-based-operators/
let elementsPerSecond = 1.0
let maxElements = 5
let replayedElements = 1
let replayDelay: TimeInterval = 3
let bag = DisposeBag()
func printValue(_ string: String) {
   let d = Date()
   let df = DateFormatter()
   df.dateFormat = "ss.SSSS"
   
   print("\(string) --- at \(df.string(from: d))")
}
/*
 Observable<Int>.create khá là quen thuộc rồi. Trong closure đó, chúng ta sẽ xử lý logic. Nhớ phải return về 1 Disposables nha.
 Sử dụng DispatchSource.makeTimerSource để tạo ra 1 timer trên main queue
 Cung cấp 1 closure cho source để xử lý sự kiện sau mỗi vòng lặp thời gian
 source.schedule lên kế hoạch phát dữ liệu theo các tham số trên
 source.resume() để kích hoạt
 Về mặt Disposables.create thì chúng ta handle luôn luôn việc dừng souce tại đây. Đây cũng chính là thắc mắc lâu nay với hàm create để làm gì.
 */

//example(of: "Basic") {
//
//
//    let observable = Observable<Int>.create({ observer -> Disposable in
//        var value = 1
//        let source = DispatchSource.makeTimerSource(queue: .main)
//        source.setEventHandler {
//            if value <= maxElements {
//                observer.onNext(value)
//            }
//            value += 1
//        }
//        source.schedule(deadline: .now(), repeating: 1.0/elementsPerSecond, leeway: .nanoseconds(0))
//        source.resume()
//        return Disposables.create {
//            source.suspend()
//        }
//    })
//
//            observable
//                .subscribe(onNext: { value in
//                    print("🔵 : ", value)
//                }, onCompleted: {
//                    print("🔵 Completed")
//                }, onDisposed: {
//                    print("🔵 Disposed")
//                })
//                .disposed(by: bag)
//
//
//    /*
//
//     🔵 :  1
//     🔵 :  2
//     🔵 :  3
//     🔵 :  4
//     🔵 :  5
//
//     */
//}










//example(of: "replay") {
//    let observable = Observable<Int>.create({ observer -> Disposable in
//        var value = 1
//        let source = DispatchSource.makeTimerSource(queue: .main)
//        source.setEventHandler {
//            if value <= maxElements {
//                observer.onNext(value)
//            }
//            value += 1
//        }
//        source.schedule(deadline: .now(), repeating: 1.0/elementsPerSecond, leeway: .nanoseconds(0))
//        source.resume()
//        return Disposables.create {
//            source.suspend()
//        }
//    })
//
//
//
//
//
//    DispatchQueue.main.asyncAfter(deadline: .now()) {
//        observable
//                .subscribe(onNext: { value in
//                    printValue("🔵 : \(value)")
//                }, onCompleted: {
//                    print("🔵 Completed")
//                }, onDisposed: {
//                    print("🔵 Disposed")
//                })
//                .disposed(by: bag)
//        }
//
//    let replaySource = observable.replay(0)
//    DispatchQueue.main.asyncAfter(deadline: .now() + replayDelay) {
//        replaySource
//                .subscribe(onNext: { value in
//                    printValue("🔴 : \(value)")
//                }, onCompleted: {
//                    print("🔴 Completed")
//                }, onDisposed: {
//                    print("🔴 Disposed")
//                })
//                .disposed(by: bag)
//        }
//    //MARK:- cần thêm
//    replaySource.connect()
///*
////    --- Example of: replay ---
//
////    🔵 : 1 --- at 06.8810
////    🔵 : 2 --- at 07.8770
////    🔵 : 3 --- at 08.8770
////    🔴 : 4 --- at 09.8470
////    🔵 : 4 --- at 09.8770
////    🔴 : 5 --- at 10.8460
////    🔵 : 5 --- at 10.8770
//
//sau 3 s thì bóng đỏ chạy, nhưng nó chỉ bắt đầu từ 4 vì mình set replay(0)
//     nếu set replay(1) thì bóng đỏ chạy từ 3
//*/
//}

example(of: "replayall") {
    let observable = Observable<Int>.create({ observer -> Disposable in
        var value = 1
        let source = DispatchSource.makeTimerSource(queue: .main)
        source.setEventHandler {
            if value <= maxElements {
                observer.onNext(value)
            }
            value += 1
        }
        source.schedule(deadline: .now(), repeating: 1.0/elementsPerSecond, leeway: .nanoseconds(0))
        source.resume()
        return Disposables.create {
            source.suspend()
        }
    })

    let replaySource = observable.replayAll()
    DispatchQueue.main.asyncAfter(deadline: .now()) {

        observable
        .subscribe(onNext: { value in
            printValue("🔵 : \(value)")
        }, onCompleted: {
            print("🔵 Completed")
        }, onDisposed: {
            print("🔵 Disposed")
        })
        .disposed(by: bag)
    }

    DispatchQueue.main.asyncAfter(deadline: .now() + replayDelay) {
        replaySource
            .subscribe(onNext: { value in
                printValue("🔴 : \(value)")
            }, onCompleted: {
                print("🔴 Completed")
            }, onDisposed: {
                print("🔴 Disposed")
            })
            .disposed(by: bag)
    }

    replaySource.connect()
}
