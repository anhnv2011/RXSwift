import UIKit
import RxSwift
import RxCocoa


//MARK:-  Transforming elements
example(of: "toArray") {
    let bag = DisposeBag()
    Observable.of("1", "2", "3", "4", "5")
        .toArray()
        .subscribe(onSuccess: { value in
            print(value)
            
        })
        .disposed(by: bag)
    /*
     --- Example of: toArray ---
     ["1", "2", "3", "4", "5"]
     
     */
    
}


example(of: "map") {
    let bag = DisposeBag()
    let formatter = NumberFormatter()
    formatter.numberStyle = .spellOut
    Observable<Int>.of(1, 2, 3, 4, 5, 11, 99)
        .map({formatter.string(from: NSNumber(value: $0)) ?? ""
        })
        .subscribe(onNext: { string in
            print(string)
            
        })
        .disposed(by: bag)
    /*
     --- Example of: map ---
     one
     two
     three
     four
     five
     eleven
     ninety-nine
     */
    
    let disposeBag = DisposeBag()
    
    Observable.of(1, 2, 3, 4, 5, 6)
        .enumerated()
        .map { index, integer in
            index > 2 ? integer * 2 : integer
        }
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
    /*
     
     1
     2
     3
     8
     10
     12
     */
    
}
struct User{
    let message: BehaviorSubject<String>
}
example(of: "flatmap") {
    
    
    let bag = DisposeBag()
    let cuty = User(message: BehaviorSubject<String>(value: "I am Ty"))
    let cuteo = User(message: BehaviorSubject<String>(value: "I am Teo"))
    let subject = PublishSubject<User>()
    
    subject
        .flatMap { $0.message }
        .subscribe(onNext: { string in
            print(string)
        })
        .disposed(by: bag)
    subject.onNext(cuty)
    cuty.message.onNext("Ty: 123")
    cuty.message.onNext(("Ty: 345"))
    subject.onNext(cuteo)
    cuteo.message.onNext("teo: 123")
    cuty.message.onNext("Ty: 789")
    cuteo.message.onNext("teo 2469")
    /*
     
     --- Example of: flatmap ---
     I am Ty
     Ty: 123
     Ty: 345
     I am Teo
     teo: 123
     Ty: 789
     teo 2469
     */
}
example(of: "flatMapLatest") {
    
    
    let bag = DisposeBag()
    let cuty = User(message: BehaviorSubject<String>(value: "I am Ty"))
    let cuteo = User(message: BehaviorSubject<String>(value: "I am Teo"))
    let subject = PublishSubject<User>()
    
    subject
        .flatMapLatest { $0.message }
        .subscribe(onNext: { string in
            print(string)
        })
        .disposed(by: bag)
    subject.onNext(cuty)
    cuty.message.onNext("Ty: 123")
    cuty.message.onNext(("Ty: 345"))
    subject.onNext(cuteo)
    cuteo.message.onNext("teo: 123")
    cuty.message.onNext("Ty: 789")
    cuteo.message.onNext("teo 2469")
    /*
     
     --- Example of: flatMapLatest ---
     I am Ty
     Ty: 123
     Ty: 345
     I am Teo
     teo: 123
     teo 2469
     
     khi cuteo join vào cuộc trò chuyện thì tất cả nhưng gì cuty bắn ra sau đó đều ko được nhận, nó khác với flatmap
     */
}


//MARK:- Observing events
example(of: "Error") {
    enum MyError: Error {
        case anError
    }
    
    let bag = DisposeBag()
    
    let cuTy = User(message: BehaviorSubject(value: "Tý: Cu Tý chào bạn!"))
    let cuTeo = User(message: BehaviorSubject(value: "Tèo: Cu Tèo chào bạn!"))
    
    let subject = PublishSubject<User>()
    
    let roomChat = subject
        .flatMapLatest { $0.message }
    
    roomChat
        .subscribe(onNext: { msg in
            print(msg)
        })
        .disposed(by: bag)
    
    subject.onNext(cuTy)
    
    cuTy.message.onNext("Tý: A")
    cuTy.message.onNext("Tý: B")
    cuTy.message.onNext("Tý: C")
    
    cuTy.message.onError(MyError.anError)
    cuTy.message.onNext("Tý: D")
    cuTy.message.onNext("Tý: E")
    
    subject.onNext(cuTeo)
    
    cuTeo.message.onNext("Tèo: 1")
    cuTeo.message.onNext("Tèo: 2")
    /*
     Tý: Cu Tý chào bạn!
     Tý: A
     Tý: B
     Tý: C
     Unhandled error happened: anError
     
     Có 1 emit error cái là sập luôn
     
     */
}

example(of: "materialize") {
    enum MyError: Error {
        case anError
    }
    
    let bag = DisposeBag()
    
    let cuTy = User(message: BehaviorSubject(value: "Tý: Cu Tý chào bạn!"))
    let cuTeo = User(message: BehaviorSubject(value: "Tèo: Cu Tèo chào bạn!"))
    
    let subject = PublishSubject<User>()
    
    let roomChat = subject
        .flatMapLatest { $0.message.materialize() }
    
    roomChat
        .subscribe(onNext: { msg in
            print(msg)
        })
        .disposed(by: bag)
    
    subject.onNext(cuTy)
    
    cuTy.message.onNext("Tý: A")
    cuTy.message.onNext("Tý: B")
    cuTy.message.onNext("Tý: C")
    
    cuTy.message.onError(MyError.anError)
    cuTy.message.onNext("Tý: D")
    cuTy.message.onNext("Tý: E")
    
    subject.onNext(cuTeo)
    
    cuTeo.message.onNext("Tèo: 1")
    cuTeo.message.onNext("Tèo: 2")
    
    /*
     --- Example of: materialize ---
     next(Tý: Cu Tý chào bạn!)
     next(Tý: A)
     next(Tý: B)
     next(Tý: C)
     error(anError)
     next(Tèo: Cu Tèo chào bạn!)
     next(Tèo: 1)
     next(Tèo: 2)

     Nó bắn ra các event (next)
     */
}

example(of: "dematerialize") {
    enum MyError: Error {
        case anError
    }
    
    let bag = DisposeBag()
    
    let cuTy = User(message: BehaviorSubject(value: "Tý: Cu Tý chào bạn!"))
    let cuTeo = User(message: BehaviorSubject(value: "Tèo: Cu Tèo chào bạn!"))
    
    let subject = PublishSubject<User>()
    
     subject
        .flatMap {
            $0.message.materialize()
        }
        .filter{
            guard $0.error == nil else {
                          print("Lỗi phát sinh: \($0.error!)")
                          return false
                      }
                      
                      return true
        }
        .dematerialize()
        .subscribe(onNext: { msg in
            print(msg)
            
        })
        .disposed(by: bag)
    
    subject.onNext(cuTy)
    
    cuTy.message.onNext("Tý: A")
    cuTy.message.onNext("Tý: B")
    cuTy.message.onNext("Tý: C")
    
    cuTy.message.onError(MyError.anError)
    cuTy.message.onNext("Tý: D")
    cuTy.message.onNext("Tý: E")
    
    subject.onNext(cuTeo)
    
    cuTeo.message.onNext("Tèo: 1")
    cuTeo.message.onNext("Tèo: 2")
    
    /*
     --- Example of: dematerialize ---
     Tý: Cu Tý chào bạn!
     Tý: A
     Tý: B
     Tý: C
     Lỗi phát sinh: anError
     Tèo: Cu Tèo chào bạn!
     Tèo: 1
     Tèo: 2
     Nó bắn ra các element
     */
}
/*
 toArray đưa tất cả phần tử được phát ra của Observavle thành 1 array. Bạn sẽ nhận được array đó khi Observable kia kết thúc.
 map toán tử huyền thoại với mục đích duy nhất là biến đổi kiểu dữ liệu này thành kiểu dữ liệu khác.
 flatMap làm phẳng các Observables thành 1 Observable duy nhất. Và các phần tử nhận được là các phần tử từ tất cả các Observables kia phát ra. Không phân biệt thứ tự đăng ký.
 flatMapLatest tương tư cái flatMap thôi. Nhưng điểm khác biệt ở chỗ chỉ nhận giá trị được phát đi của Observable cuối cùng tham gia vào.
 materialize thay vì nhận giá trị được phát đi. Nó biến đổi các events thành giá trị để phát đi. Lúc này, error hay completed thì cũng là 1 giá trị mà thôi.
 dematerialize thì ngược lại materialize. Giải nén các giá trị là events để lấy giá trị thật sự trong đó.

 */
