import UIKit
import RxSwift


example(of: "Just, Of, From") {
    let iOS = 1
    let android = 2
    let flutter = 3
    
    //MARK:- Kiểu just: phát đi 1 giá trị duy nhất sau đó nó kết thúc
    //just là toán tử để tạo ra 1 observable sequence với 1 phần tử duy nhất
    //<Int> chính là kiểu dữ liệu cho Output của Observable
    let observable1 = Observable<Int>.just(iOS)
    observable1.subscribe { (value) in
        print("observable1: \(value)")
    }
    
    print("----------------------------------------------------")
    //MARK:- Kiểu of
    let observable2 = Observable.of(iOS, android, flutter)
    observable2.subscribe { (value) in
        //print("observables2: \(value)")
        if let element = value.element {
            print("observables2 with out next and comple: \(element)")
        } // viết thế này sẽ ko còn onnext và completed
    }
    //Ta thấy đối tượng Observable lần này sử dụng toán tử of
    //Không cần khai báo kiểu dữ liệu cho Output
    //Thư viện tự động nội suy ra kiểu dữ liệu từ các dữ liệu cung cấp trong of(.....)
    
//    observables2 with out next and comple: 1
//    observables2 with out next and comple: 2
//    observables2 with out next and comple: 3

    
    print("----------------------------------------------------")
    
    let observable3 = Observable.of([iOS, android, flutter])
    observable3.subscribe(onNext: { element in
        print("observables3 without next by use onNext: \(element)")
    }) //Dùng onNext thì lấy luôn được element
    //Cũng vẫn là of , nhưng kiểu dữ liệu cho observable3 lúc này là Observable<[Int]>. Nó khác cái trên ở chỗ kiểu cho mỗi giá trị phát ra là 1 Array Int, chứ không phải Int riêng lẻ. Nó cũng khá nhập nhèn dữ liệu ở đây.
    
//    observables3 without next by use onNext: [1, 2, 3]

    
    print("----------------------------------------------------")
    
    //MARK:- Kiểu from
    
    let observable4 = Observable.from([iOS, android, flutter])
    
    observable4.subscribe(onNext: { (value) in
        print(value)
    }, onError: { (error) in
        print(error.localizedDescription)
    }, onCompleted: {
        print("Completed")
    }) {
        print("Disposed")
    }
}

//1
//2
//3
//Completed
//Disposed

print("----------------------------------------------------")
//Never thì sẽ không phát ra gì cả và cũng không kết thúc luôn.

//MARK:- Kiểu from

example(of: "empty") {
    let observable = Observable<Void>.empty()
    
    observable.subscribe(
        onNext: { element in
            print("empty element: \(element)")
        },
        onCompleted: {
            print("Completed empty")
        }
    )
}


print("----------------------------------------------------")
example(of: "never") {
    let observable = Observable<Any>.never()
    
    observable.subscribe(
        onNext: { element in
            print("never: \(element)")
        },
        onCompleted: {
            print("Completed never")
        }
    ).dispose()
}


print("----------------------------------------------------")
example(of: "range") {
    let observable = Observable<Int>.range(start: 1, count: 10)
    var sum = 0
    observable
        .subscribe(
            onNext: { i in
                sum += i
        } , onCompleted: {
            print("Sum = \(sum)")
        }
    )


}

