import UIKit
import RxSwift

//MARK:- dispose

example(of: "Dispose") {
    let observable = Observable<String>.of("A", "B", "C", "D", "E", "F")

    //Khi một Observable được tạo ra, nó sẽ không hoạt động hay hành động gì cho tới khi có 1 subscriber đăng ký tới. Việc subscriber khi đăng ký tới thì gọi là subscription
    let subscription = observable.subscribe { event in
        print(event)
    }
    subscription.dispose() // dừng phát của observable

}

//MARK:- DisposeBag
example(of: "DisposeBag") {
    let bag = DisposeBag()
    Observable<String>.of("A", "B", "C", "D", "E", "F").subscribe { (value) in
        print(value)
    }.disposed(by: bag)

}

//MARK:- Dispose vs. DisposeBag


print("Note, 1 doan ko co print ...............")
//dispose Với 1 subscription
final class ViewController: UIViewController {
    var subscription: Disposable?
    let theObservable = Observable<String>.of("k", "l", "M", "D", "E", "F")
    override func viewDidLoad() {
        super.viewDidLoad()
        subscription = theObservable.subscribe(onNext: { _ in
            // handle subscription
        })
    }

    deinit {
        subscription?.dispose()
    }
}

// disposeVới nhiều subscription
final class ViewController2: UIViewController {
    var subscriptions = [Disposable]()
    let theObservable = Observable<String>.of("k", "l", "M", "D", "E", "F")
    override func viewDidLoad() {
        super.viewDidLoad()
        subscriptions.append(theObservable.subscribe(onNext: { _ in
            // handle subscription
        }))
    }
    
    deinit {
        subscriptions.forEach { $0.dispose() }
    }
}

//Nếu dùng dispose bag thì ko cần hàm deinit
//DisposeBag, là nó sẽ chịu trách nhiệm cho việc gọi dispose trên mỗi Disposable bên trong nó. Việc này sẽ được gọi khi bản thân DisposeBag bị deinit.
final class ViewControlle3r: UIViewController {
    let disposeBag = DisposeBag()
    let theObservable = Observable<String>.of("k", "l", "M", "D", "E", "F")
    override func viewDidLoad() {
        super.viewDidLoad()
        theObservable.subscribe(onNext: { _ in
                // handle subscription
        })
        .disposed(by: disposeBag)
    }
}

print("----------------------------------------------------")

//MARK:- Disposable
/*
Disposable là một protocol với một phương thức dispose()
public protocol Disposable {
    func dispose()
}

Khi subscribe một Observable, Disposable giữ một tham chiếu đến Observable và Observable này giữ strong reference đến Disposable (Rx tạo ra một loại retain cycle). Nhờ vậy, khi user quay lại màn hình trước đó, Observable sẽ không bị giải phóng cho đến khi ta muốn giải phóng nó
 NẾU không nó sẽ ko gọi hay dispose
 */
example(of: "Create") {   //.create tạo ra một Observable và cài đặt các hành vi cho nó.
    enum MyError: Error {
      case anError
    }
    
    let bag = DisposeBag()
 
    Observable<String>.create { observer -> Disposable in
        observer.onNext("1")
        
        observer.onNext("2")
        
        observer.onNext("3")
        
        observer.onNext("4")
        
        //observer.onError(MyError.anError)  // sẽ dừng và phát error
        
        observer.onNext("5")
        
        //observer.onCompleted() // sẽ dừng và phát completed
        
        observer.onNext("6")
        
        return Disposables.create()
    }
    .subscribe(
        onNext: { print($0) },
        onError: { print($0) },
        onCompleted: { print("Completed") },
        onDisposed: { print("Disposed") }
        )
//    .disposed(by: bag)
    
/*
     Như vậy, nếu không có disposeBag và không có việc phát ra error hay completed, thì subscribe sẽ vẫn đứng đó chờ Observable. Và subscription sẽ không kết thúc được.
    
     */
}
