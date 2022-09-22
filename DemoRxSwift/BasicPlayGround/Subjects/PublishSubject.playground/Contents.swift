import UIKit
import RxSwift
import RxCocoa


//MARK:- Publish Subject
//PublishSubject: Khởi đầu empty và chỉ emit các element mới cho Subscriber của nó.
/*
 
 Từ đó, bạn có các đặc điểm sau cho 1 Publish Subject:

 Chỉ phát đi giá trị mới nhất
 Khi khởi tạo Publish Subject thì không cần cung cấp giá trị ban đầu cho nó.
 Các Subscriber sau chỉ nhận được giá trị khi Subject phát
 Không nhận được các giá trị trước khi subscribe
 Subject kết thúc khi phát đi .completed hoặc .error
 Subscription sẽ kết thúc khi nó .dispose()
 Khi subject đã .completed , thì các subscriber mới chỉ nhận được sự kiện đó mà thôi.

 */
example(of: "Hello Subject") {
    let disposeBag = DisposeBag()

    let subject = PublishSubject<String>()
    subject.onNext("Chào bạn")  // ko hien
    let subcription = subject.subscribe(onNext: { element in
        print(element)
        
    })
    subject.onNext("Chào bạn lần nữa")
    subject.onNext("Chào bạn lần thứ 3")
    subject.onNext("Mình đứng đây từ chiều")
    subcription.disposed(by: disposeBag)
}

print("--------------------------------------------------------------------------")

example(of: "Publish Subject") {
    let disposeBag = DisposeBag()
    let subject = PublishSubject<String>()
    
    subject.onNext("1")
    
    let subscription1 = subject
        .subscribe(onNext: { value in
            print("Sub 1: ", value)
        }, onCompleted: {
            print("sub 1: completed")
        })
        .disposed(by: disposeBag)
    
        
    subject.onNext("2")
    
    let subscription2 = subject
        .subscribe(onNext: { value in
            print("Sub 2: ", value)
        }, onCompleted: {
            print("sub 2: completed")
        })
    
    subject.onNext("3")
    subject.onNext("4")
    subject.onNext("5")
    
    subscription2.dispose()
    subject.onNext("6")
    subject.onNext("7")
    
    subject.on(.completed)
    subject.onNext("8")
    
    subject.subscribe {
        print("sub 3: ", $0.element ?? $0)
    }
    .disposed(by: disposeBag)
}

//--- Example of: Publish Subject ---
//Sub 1:  2
//Sub 1:  3
//Sub 2:  3
//Sub 1:  4
//Sub 2:  4
//Sub 1:  5
//Sub 2:  5
//Sub 1:  6
//Sub 1:  7
//sub 1: completed
//sub 3:  completed
