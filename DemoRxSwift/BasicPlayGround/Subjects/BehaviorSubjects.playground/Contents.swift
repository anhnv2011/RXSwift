import UIKit
import RxSwift

/*Behavior Subject sẽ phát đi các giá trị cuối cùng của nó cho các subscirber khi đăng ký tới nó.
 Đảm bảo các subscriber luôn nhận được giá trị khi đăng ký tới
 Phải cung cấp giá trị ban đầu khi khởi tạo subject
 Khi subject kết thúc thì các subcriber mới sẽ nhận được .error hay .completed.
 */
example(of: "Behavior Subject") {
    let disposeBag = DisposeBag()
    
    enum MyError: Error {
      case anError
    }
    
    let subject = BehaviorSubject(value: "0")
    
    //Subscribe 1
    subject .subscribe {
        print("Subscribe 1 ", $0)
      }
    .disposed(by: disposeBag)
    
    // emit
    subject.onNext("1")
    
    //Subscribe 2
    subject .subscribe {
        print("Subscribe 2 ", $0)
      }
    .disposed(by: disposeBag)
    
    // error
    subject.onError(MyError.anError)
    
    //Subscribe 3
    subject .subscribe {
        print("Subscribe 3 ", $0)
      }
    .disposed(by: disposeBag)
}
//--- Example of: Behavior Subject ---
//Subscribe 1  next(0)
//Subscribe 1  next(1)
//Subscribe 2  next(1)
//Subscribe 1  error(anError)
//Subscribe 2  error(anError)
//Subscribe 3  error(anError)
