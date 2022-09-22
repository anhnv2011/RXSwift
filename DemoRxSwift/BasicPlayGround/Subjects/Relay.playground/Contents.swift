import UIKit
import RxSwift
import RxCocoa
/*
 Thứ nhất, Relay là một wraps cho một subject. Tuy nhiên, nó không giống như các subject hay các observable chung chung. Ở một số đặc điểm sau:
 
 Không có hàm .onNext(_:) để phát đi dữ liệu
 Dữ liệu được phát đi bằng cách sử dụng hàm .accept(_:)
 Chúng sẽ không bao giờ .error hay .completed
 Thứ hai, nó sẽ liên quan tới 2 Subject khác. Do đó, ta có 2 loại Relay
 
 PublishRelay đó là warp của PublishSubject. Relay này mang đặc tính của PublishSubject
 BehaviorRelay đó là warp của BehaviorSubject. Nó sẽ mang các đặc tính của subject này
 */

example(of: "Publish Relay") {
    //dispose
    let bag = DisposeBag()
    //error define
    enum MyError: Error {
        case anError
    }
    
    let publishRelay = PublishRelay<String>()
    
    publishRelay.accept("0")
    
    //subcribe 1
    publishRelay.subscribe{
        print("publishRelay1", $0)
    }.disposed(by: bag)
    
    publishRelay.accept("1")
    publishRelay.accept("2")
    publishRelay.accept("3")

    //subcribe 2
    publishRelay.subscribe {
        print("publishRelay2", $0)
    }

    publishRelay.accept("4")
    
//    Bạn không thể kết thúc Relay được, vì chúng không hề phát đi error hay completed.  Việc phát đi error & completed thì đều bị trình biên dịch ngăn cản.
//
//    publishRelay.accept(MyError.anError)
//    publishRelay.onCompleted()
}
//--- Example of: Publish Relay ---
//publishRelay1 next(1)
//publishRelay1 next(2)
//publishRelay1 next(3)
//publishRelay1 next(4)
//publishRelay2 next(4)






example(of: "Behavior Relay") {
    //dispose
    let bag = DisposeBag()
    //error define
    enum MyError: Error {
        case anError
    }
    
    let behaviorRelay = BehaviorRelay<String>(value: "0")
       
//       behaviorRelay.accept("0")
       
       // subcribe 1
       behaviorRelay
         .subscribe {
            print("Behavior Relay 1 ", $0)
            
         }
         .disposed(by: bag)
       
       behaviorRelay.accept("1")
       behaviorRelay.accept("2")
       behaviorRelay.accept("3")
       
       // subcribe 2
       behaviorRelay
         .subscribe {
            print("Behavior Relay 2 ", $0)
            
         }
         .disposed(by: bag)
       
       behaviorRelay.accept("4")
       
       // current value
       print("Current value: \(behaviorRelay.value)")
}

//--- Example of: Behavior Relay ---
//Behavior Relay 1  next(0)
//Behavior Relay 1  next(1)
//Behavior Relay 1  next(2)
//Behavior Relay 1  next(3)
//Behavior Relay 2  next(3)
//Behavior Relay 1  next(4)
//Behavior Relay 2  next(4)
//Current value: 4


/*
Relay là wrap một subject
Đặc điểm
Không có .onNext, .onError và .onCompleted
Phát giá trị đi bằng .accpet(_:)
Không bao giờ kết thúc
Các class của Relay sẽ có các đặc tính của class mà nó wrap lại.
PublishRelay là wrap của PublishSubject
BehaviorRelay là wrap của BehaviorSubject
*/
