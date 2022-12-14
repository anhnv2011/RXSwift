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
     
     khi cuteo join v??o cu???c tr?? chuy???n th?? t???t c??? nh??ng g?? cuty b???n ra sau ???? ?????u ko ???????c nh???n, n?? kh??c v???i flatmap
     */
}


//MARK:- Observing events
example(of: "Error") {
    enum MyError: Error {
        case anError
    }
    
    let bag = DisposeBag()
    
    let cuTy = User(message: BehaviorSubject(value: "T??: Cu T?? ch??o b???n!"))
    let cuTeo = User(message: BehaviorSubject(value: "T??o: Cu T??o ch??o b???n!"))
    
    let subject = PublishSubject<User>()
    
    let roomChat = subject
        .flatMapLatest { $0.message }
    
    roomChat
        .subscribe(onNext: { msg in
            print(msg)
        })
        .disposed(by: bag)
    
    subject.onNext(cuTy)
    
    cuTy.message.onNext("T??: A")
    cuTy.message.onNext("T??: B")
    cuTy.message.onNext("T??: C")
    
    cuTy.message.onError(MyError.anError)
    cuTy.message.onNext("T??: D")
    cuTy.message.onNext("T??: E")
    
    subject.onNext(cuTeo)
    
    cuTeo.message.onNext("T??o: 1")
    cuTeo.message.onNext("T??o: 2")
    /*
     T??: Cu T?? ch??o b???n!
     T??: A
     T??: B
     T??: C
     Unhandled error happened: anError
     
     C?? 1 emit error c??i l?? s???p lu??n
     
     */
}

example(of: "materialize") {
    enum MyError: Error {
        case anError
    }
    
    let bag = DisposeBag()
    
    let cuTy = User(message: BehaviorSubject(value: "T??: Cu T?? ch??o b???n!"))
    let cuTeo = User(message: BehaviorSubject(value: "T??o: Cu T??o ch??o b???n!"))
    
    let subject = PublishSubject<User>()
    
    let roomChat = subject
        .flatMapLatest { $0.message.materialize() }
    
    roomChat
        .subscribe(onNext: { msg in
            print(msg)
        })
        .disposed(by: bag)
    
    subject.onNext(cuTy)
    
    cuTy.message.onNext("T??: A")
    cuTy.message.onNext("T??: B")
    cuTy.message.onNext("T??: C")
    
    cuTy.message.onError(MyError.anError)
    cuTy.message.onNext("T??: D")
    cuTy.message.onNext("T??: E")
    
    subject.onNext(cuTeo)
    
    cuTeo.message.onNext("T??o: 1")
    cuTeo.message.onNext("T??o: 2")
    
    /*
     --- Example of: materialize ---
     next(T??: Cu T?? ch??o b???n!)
     next(T??: A)
     next(T??: B)
     next(T??: C)
     error(anError)
     next(T??o: Cu T??o ch??o b???n!)
     next(T??o: 1)
     next(T??o: 2)

     N?? b???n ra c??c event (next)
     */
}

example(of: "dematerialize") {
    enum MyError: Error {
        case anError
    }
    
    let bag = DisposeBag()
    
    let cuTy = User(message: BehaviorSubject(value: "T??: Cu T?? ch??o b???n!"))
    let cuTeo = User(message: BehaviorSubject(value: "T??o: Cu T??o ch??o b???n!"))
    
    let subject = PublishSubject<User>()
    
     subject
        .flatMap {
            $0.message.materialize()
        }
        .filter{
            guard $0.error == nil else {
                          print("L???i ph??t sinh: \($0.error!)")
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
    
    cuTy.message.onNext("T??: A")
    cuTy.message.onNext("T??: B")
    cuTy.message.onNext("T??: C")
    
    cuTy.message.onError(MyError.anError)
    cuTy.message.onNext("T??: D")
    cuTy.message.onNext("T??: E")
    
    subject.onNext(cuTeo)
    
    cuTeo.message.onNext("T??o: 1")
    cuTeo.message.onNext("T??o: 2")
    
    /*
     --- Example of: dematerialize ---
     T??: Cu T?? ch??o b???n!
     T??: A
     T??: B
     T??: C
     L???i ph??t sinh: anError
     T??o: Cu T??o ch??o b???n!
     T??o: 1
     T??o: 2
     N?? b???n ra c??c element
     */
}
/*
 toArray ????a t???t c??? ph???n t??? ???????c ph??t ra c???a Observavle th??nh 1 array. B???n s??? nh???n ???????c array ???? khi Observable kia k???t th??c.
 map to??n t??? huy???n tho???i v???i m???c ????ch duy nh???t l?? bi???n ?????i ki???u d??? li???u n??y th??nh ki???u d??? li???u kh??c.
 flatMap l??m ph???ng c??c Observables th??nh 1 Observable duy nh???t. V?? c??c ph???n t??? nh???n ???????c l?? c??c ph???n t??? t??? t???t c??? c??c Observables kia ph??t ra. Kh??ng ph??n bi???t th??? t??? ????ng k??.
 flatMapLatest t????ng t?? c??i flatMap th??i. Nh??ng ??i???m kh??c bi???t ??? ch??? ch??? nh???n gi?? tr??? ???????c ph??t ??i c???a Observable cu???i c??ng tham gia v??o.
 materialize thay v?? nh???n gi?? tr??? ???????c ph??t ??i. N?? bi???n ?????i c??c events th??nh gi?? tr??? ????? ph??t ??i. L??c n??y, error hay completed th?? c??ng l?? 1 gi?? tr??? m?? th??i.
 dematerialize th?? ng?????c l???i materialize. Gi???i n??n c??c gi?? tr??? l?? events ????? l???y gi?? tr??? th???t s??? trong ????.

 */
