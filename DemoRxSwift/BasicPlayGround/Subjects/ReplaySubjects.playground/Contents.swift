import UIKit
import RxSwift

/*
 Đây cũng là một loại Subject. Đặc điểm của loại subject này, khi phát đi các giá trị thì đồng thời nó lưu lại các giá trị đó trong bộ đệm của mình. Và khi có một subscriber đăng kí tới, subject này sẽ phát đi các giá trị trong bộ đêm của nó cho subscriber đó.

 Ta có các đặc điểm sau của loại Subject này:

 Khởi tạo bằng kích thước bộ đệm của subject
 Khi phát đi 1 phần tử thì đồng thời lưu trữ nó vào bộ đệm
 Khi có subscriber mới tới thì sẽ nhận được toàn bộ phần tử trong bộ đệm
 
 Ngay cả khi subject phát đi error hay completed thì các subscriber mới vẫn sẽ nhận được đầy đủ các giá trị trong bộ đệm và error hay completed cuối cùng đó.
 Khi sử dụng toán tử dispose() của subject thì toàn bộ mọi thứ sẽ được xoá hết. Nên các subscriber mới lúc đó sẽ không nhận được gì ngoài error.
 */
example(of: "RelaySubject") {
    let disposedBag = DisposeBag()
    enum MyError: Error {
        case anError
    }
    
    let subject = ReplaySubject<String>.create(bufferSize: 2) //Bộ đệm chỉ lưu 2 giá trị
    //let subject = ReplaySubject<String>.createUnbounded() // lưu toàn bộ giá trị
    
    //emit
    subject.onNext("1")
    subject.onNext("2")
    subject.onNext("3")
    
    subject.subscribe({
        print("Subcription 1:", $0)   // in ra 2, 3
    }).disposed(by: disposedBag)
    
    subject.onNext("4")
    subject.subscribe({ value in
        
        print("Subcription 2:\(value)")                // in ra 3 4
    }).disposed(by: disposedBag)
    
    subject.onError(MyError.anError)
    
    subject.dispose()  // Nếu ko có dòng này thì subcribe vẫn sẽ nhận giá trị trong bộ đệm kể cả đã error hay complete và ở đây là 3 và 4 sau đó erorr
    
    // subcribe 3
       subject
         .subscribe {
            print("Subcription 3 ", $0)
            
         }
         .disposed(by: disposedBag)
       
}
