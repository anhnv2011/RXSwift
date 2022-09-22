import UIKit
import RxSwift
example(of: "Factory") {
    let bag = DisposeBag()
    
    var flip = true
    
    
    // deferred: trì hoãn tính toán cho đến khi đăng ký
    let factory = Observable<Int>.deferred {
        flip.toggle()
        
        if flip {
            return Observable.of(1)
        } else {
            return Observable.of(0)
        }
    }
//    .deferred tạo ra 1 Observable nhưng sẽ trì hoãn nó lại. Và nó sẽ được return trong closure xử lí được gán kèm theo.
    
    for _ in 0...10 {
        factory.subscribe(
            onNext: { print($0) })
            .disposed(by: bag)
    
        //print()
    }
}

/*
- create là cách linh hoạt nhất để tạo ra một Observable
- just sẽ giúp bạn biến 1 giá trị thành 1 Observable. Ngoài ra, nó còn những người anh em thân thương của mình nữa. Với mỗi loại cho một nhiệm vụ đặc biệt.
- deferred trì hoãn việc phát dữ liệu khi có 1 subscription tới. Giúp cho bạn có thời gian để xử lý dữ liệu trước khi gởi đi
 */
