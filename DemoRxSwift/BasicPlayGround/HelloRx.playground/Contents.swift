import UIKit
import RxSwift
let arrString = ["a", "b", "c"]
let helloRx = Observable.just("Hello RX")
helloRx.subscribe { (value) in
    print(value)
}
// helloRx là 1 biến observable (là nguồn phát ra 1 sự kiện hoặc 1 dữ liệu nào đó mà các đối tượng có thể quan sát và đăng ký được-subscribe )
// just là chỉ tạo ra 1 lần duy nhất
// dữ liệu phát  đi là "Hello RxSwift"
// để lắng nghe helloRx thì bạn cần theo dõi nó subscribe
// chúng ta cung cấp 1 closure để xử lý giá trị nhận được từ nguồn phát
// sau khi nguồn phát phát ra chữ "Hello RxSwift" nó sẽ ra tín hiệu kết thúc là completed

//Sequence : là luồng dữ liệu được nguồn phát phát đi. Vấn đề quan trọng, bạn cần hiểu nó như 1 Array, nhưng chúng ta không thể lấy hết 1 lúc tất cả các giá trị của nó. Và chúng ta không biết nó lúc nào kết thúc hay lúc nào lỗi …


    let subject = PublishSubject<String>()
    subject.onNext("Chào bạn")
    let subcription = subject.subscribe(onNext: { element in
        print(element)
        
    })
    subject.onNext("Chào bạn lần nữa")
    subject.onNext("Chào bạn lần thứ 3")
    subject.onNext("Mình đứng đây từ chiều")

