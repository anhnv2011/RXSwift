import UIKit
import RxSwift
import RxCocoa


example(of: "startWith") {
    let bag = DisposeBag()
    
    Observable.of("B", "C", "D", "E")
        .startWith("A", "A1", "A2")
        .subscribe(onNext: { value in
            print(value)
        })
        .disposed(by: bag)
    
    /*
     --- Example of: startWith ---
     A
     A1
     A2
     B
     C
     D
     E
     
     Phát với các giá trị khởi tạo cung cấp sẵn
     */
}

example(of: "Observable.concat") {
    let bag = DisposeBag()
    
    let first = Observable.of(1, 2, 3)
    let second = Observable.of(4, 5, 6)

    let observable = Observable.concat([first, second])

    observable
        .subscribe(onNext: { value in
            print(value)
        })
        .disposed(by: bag)
    /*
     --- Example of: Observable.concat ---
     1
     2
     3
     4
     5
     6
     
     Nối các phần tử của nhiều sequence vào với nhau
     */
}

example(of: "concat") {
    let bag = DisposeBag()
    
    let first = Observable.of("A", "B", "C")
    let second = Observable.of("D", "E", "F")
    
    let observable = first.concat(second)
    
    observable
        .subscribe(onNext: { value in
            print(value)
        })
        .disposed(by: bag)
    
        /*
     --- Example of: concat ---
     A
     B
     C
     D
     E
     F
         */
}

example(of: "concatMap") {
    let bag = DisposeBag()
    
    let cities = [ "Mien Bac" : Observable.of("Ha Noi", "Hai Phong"),
                   "Mien Trung" : Observable.of("Hue", "Da Nang"),
                   "Mien Nam" : Observable.of("Ho Chi Minh", "Can Tho")]
    
    let observable = Observable.of("Mien Bac", "Mien Trung", "Mien Nam")
        .concatMap { name in
            cities[name] ?? .empty()
        }
    
    observable
        .subscribe(onNext: { (value) in
            print(value)
        })
        .disposed(by: bag)
    /*
     --- Example of: concatMap ---
     Ha Noi
     Hai Phong
     Hue
     Da Nang
     Ho Chi Minh
     Can Tho
     */
}

example(of: "merge") {
    let bag = DisposeBag()
    
    let chu = PublishSubject<String>()
    let so = PublishSubject<String>()
    
    let source = Observable.of(chu.asObserver(), so.asObserver())
    
    let observable = source.merge()
    
    observable
        .subscribe(onNext: { (value) in
            print(value)
        })
        .disposed(by: bag)
    
    chu.onNext("Một")
    so.onNext("1")
    chu.onNext("Hai")
    so.onNext("2")
    chu.onNext("Ba")
    so.onCompleted()
    so.onNext("3")
    chu.onNext("Bốn")
    chu.onCompleted()
    
    /*
     --- Example of: merge ---
     Một
     1
     Hai
     2
     Ba
     Bốn

     */
}

example(of: "combinedLatest") {
    let bag = DisposeBag()
    
    let chu = PublishSubject<String>()
    let so = PublishSubject<String>()
    //let observable = Observable.combineLatest(chu, so)

    let observable = Observable.combineLatest(chu, so) { chu, so in
        "\(chu) : \(so)"
    }
    
    observable
        .subscribe(onNext: { (value) in
            print(value)
        })
    .disposed(by: bag)
    
    chu.onNext("Một")
    chu.onNext("Hai")
    so.onNext("1")
    so.onNext("2")
    
    chu.onNext("Ba")
    so.onNext("3")
    chu.onCompleted()
    chu.onNext("Bốn")
    
    so.onNext("4")
    so.onNext("5")
    so.onNext("6")
    
    
    so.onCompleted()
    /*
     --- Example of: combinedLatest ---
     Hai : 1
     Hai : 2
     Ba : 2
     Ba : 3
     Ba : 4
     Ba : 5
     Ba : 6
     Khong co "Một", "1"). Vì lúc đó Observable so chưa phát ra gì cả. Khi so phát ra phần tử đầu tiên thì sẽ kết hợp với phần tử mới nhất của chu, đó là Hai
     Luôn kết hợp với 1 phần tử mới nhất
     Thêm  onCompleted() ko ảnh hưởng gì, nó vẫn lấy dữ liệu cuối cùng
     */
}

example(of: "combine user choice and value") {
    let choice: Observable<DateFormatter.Style> = Observable.of(.short, .long)

    let dates = Observable.of(Date())

   
    let observable = Observable.combineLatest(choice, dates) { format, when -> String in
        let formatter = DateFormatter()
        formatter.dateStyle = format
        return formatter.string(from: when)
    }
    
    _ = observable.subscribe(onNext: { value in
        print(value)
    })
    /*
     --- Example of: combine user choice and value ---
     8/16/22
     August 16, 2022
     */
    
}

example(of: "zip") {
    let bag = DisposeBag()
    
    let chu = PublishSubject<String>()
    let so = PublishSubject<String>()
    
    let observable = Observable.zip(chu, so) { chu, so in
        "\(chu) : \(so)"
    }
    
    observable
        .subscribe(onNext: { (value) in
            print(value)
        })
    .disposed(by: bag)
    
    chu.onNext("Một")
    chu.onNext("Hai")
    so.onNext("1")
    so.onNext("2")
    
    chu.onNext("Ba")
    so.onNext("3")
    chu.onCompleted()
    chu.onNext("Bốn")
    
    so.onNext("4")
    so.onNext("5")
    so.onNext("6")
    
    so.onCompleted()
    /*
     --- Example of: zip ---
     Một : 1
     Hai : 2
     Ba : 3
     
     Kết hợp theo thú tự ko quan tâm bắn đi bao lần
     */
}

example(of: "withLatestFrom") {
  
  let button = PublishSubject<Void>()
  let textField = PublishSubject<String>()

    let observable = button.withLatestFrom(textField)
    
    _ = observable
        .subscribe(onNext: { value in
            print(value)
        })

    textField.onNext("Đa")
    textField.onNext("Đà Na")
    textField.onNext("Đà Nẵng")
    
    button.onNext(())
    button.onNext(())
    /*
     --- Example of: withLatestFrom ---
     Đà Nẵng
     Đà Nẵng

     button là một subject. Với Void thì chỉ phát ra sự kiện, chứ không có giá trị nào từ onNext
     textField là một subject, phát ra các String
     observable là sự kết hợp của button với textField thông qua toán tử withLatestFrom
     Mỗi lần button phát đi tín hiệu, thì kết quả sẽ nhận được là phần tử mới nhất từ textField
     Qua ví dụ trên cũng mô tả cho bạn thấy sự hoạt động của toán tử withLatestFrom rồi. Kết quả thực thi code như sau:
     Đà Nẵng
     Đà Nẵng
     */
}

example(of: "sample") {
  
    let button = PublishSubject<Void>()
    let textField = PublishSubject<String>()

    let observable = textField.sample(button)
    
    _ = observable
        .subscribe(onNext: { value in
            print(value)
        })

    textField.onNext("Đa")
    textField.onNext("Đà Na")
    textField.onNext("Đà Nẵng")
    
    button.onNext(())
    button.onNext(())
    /*
     --- Example of: sample ---
     Đà Nẵng
     
     Với sample là tương tự như withFromLatest. Nhưng nó chỉ phát khi Observable button phát ra.


     */
}

example(of: "amb") {
    
    /*
     Nó sẽ tạo ra một Observable để giải quyết vấn đề quyết định nhận dữ liệu từ nguồn nào
     Trong khi cả 2 nguồn đều có thể phát dữ liệu. Thì nguồn nào phát trước, thì nó sẽ nhận dữ liệu từ nguồn đó.
     Nguồn phát sau sẽ bị âm thầm ngắt kết nối
     */
    let bag = DisposeBag()
    
    let chu = PublishSubject<String>()
    let so = PublishSubject<String>()
    
    let observable = chu.amb(so)
    
    observable
        .subscribe(onNext: { (value) in
            print(value)
        })
    .disposed(by: bag)
    
    so.onNext("1")
    so.onNext("2")
    so.onNext("3")
    
    chu.onNext("Một")
    chu.onNext("Hai")
    chu.onNext("Ba")
    
    so.onNext("4")
    so.onNext("5")
    so.onNext("6")
       
    chu.onNext("Bốn")
    chu.onNext("Năm")
    chu.onNext("Sáu")
    /*
     vì số bắn trước nên nó chỉ nhận số
     --- Example of: amb ---
     1
     2
     3
     4
     5
     6

     */
}

example(of: "switchLatest") {
    
    let chu = PublishSubject<String>()
    let so = PublishSubject<String>()
    let dau = PublishSubject<String>()
    
    let observable = PublishSubject<Observable<String>>()
    
    let subscription = observable
        .switchLatest()
        .subscribe(onNext: { (value) in
            print(value)
        }, onCompleted: {
            print("completed")
        }, onDisposed: {
            print("disposed")
        })
        
    
    observable.onNext(so)
    
    so.onNext("1")
    so.onNext("2")
    so.onNext("3")
    
    observable.onNext(chu)
    
    chu.onNext("Một")
    chu.onNext("Hai")
    chu.onNext("Ba")
    
    so.onNext("4")
    so.onNext("5")
    so.onNext("6")
    
    observable.onNext(dau)
    
    dau.onNext("+")
    dau.onNext("-")
    
    observable.onNext(chu)
    chu.onNext("Bốn")
    chu.onNext("Năm")
    chu.onNext("Sáu")

    subscription.dispose()
    /*
     1
     2
     3
     Một
     Hai
     Ba
     +
     -
     Bốn
     Năm
     Sáu
     disposed

    
     */
}

example(of: "reduce") {
    let source = Observable.of(1, 2, 3, 4, 5, 6, 7, 8, 9)

    //let observable = source.reduce(0, accumulator: +)
    
    //let observable = source.reduce(0) { $0 + $1 }
    
    let observable = source.reduce(0) { summary, newValue in
      return summary + newValue
    }
    
    _ = observable
        .subscribe(onNext: { value in
            print(value)
        })
    /*
     --- Example of: reduce ---
     45

     */
}

example(of: "scan") {
    let source = Observable.of(1, 2, 3, 4, 5, 6, 7, 8, 9)

    //let observable = source.scan(0, accumulator: +)
    
    //let observable = source.scan(0) { $0 + $1 }
    
    let observable = source.scan(0) { summary, newValue in
      return summary + newValue
    }
    
    _ = observable
        .subscribe(onNext: { value in
            print(value)
        })
    /*
     --- Example of: scan ---
     1
     3
     6
     10
     15
     21
     28
     36
     45

     */
}


example(of: "test scan") {
    struct Detail {
        var name: String
    }
    
    struct Master {
        var name: String
        var items = [Detail]()
    }
    
    let masters = [Master(name: "1"),
                   Master(name: "2"),
                   Master(name: "3"),
                   Master(name: "4")]
    
    let details = [[Detail(name: "1-1"), Detail(name: "1-2"), Detail(name: "3-1") , Detail(name:                    "4-1")],
                   [Detail(name: "2-1"), Detail(name: "2-2"), Detail(name: "3-2") , Detail(name: "4-2")],
                   [Detail(name: "3-1"), Detail(name: "2-3"), Detail(name: "3-3") , Detail(name: "4-3")],
                   [Detail(name: "4-1"), Detail(name: "2-4"), Detail(name: "3-4") , Detail(name: "4-4")]]
    
    let source = PublishSubject<[Master]>()
    let list = PublishSubject<[Detail]>()
    
    
    
    source.onNext(masters)
    list.onNext(details[0])
    list.onNext(details[1])
    list.onNext(details[2])
    list.onNext(details[3])
    /*
     
     */
    
}
/*
Mình sẽ tóm tắt lại ý nghĩa các toán tử trong nhóm Combining Operators nha.

startWith để thêm một hoặc nhiều phần tử trước khi Observable phát ra giá trị đầu tiên.
concat dùng để nối nhiều Observables lại với nhau. Hoặc tiếp tục việc phát dữ liệu sau khi một Observable kết thúc bằng 1 Observable khác.
concatMap vừa nối vừa biến đổi
merge hợp nhất các giá trị từ nhiều Observables phát ra (không theo thứ tự) thành 1 Observable duy nhất.
combineLatest kết hợp các cặp giá trị mới nhất từ các Observables. Và không quan tâm tới thứ tự phát.
zip tương tự như combineLatest nhưng cặp giá trị kết hợp sẽ theo thứ tự phát của các Observables.
withLatestFromlà trigger với tham số là dữ liệu của một Observable khác. Nó phát và nhận giá trị từ người khác.
sample cũng là trigger, nhưng tham số là một Observable khác. Khi người khác phát thì nó sẽ phát ra dữ liệu.
amb giải quyết việc chọn Observables nào sẽ toàn quyền phát dữ liệu. Bằng cách xem Observable nào phát trước tiên, các Observable còn lại thì sẽ bị ngắt kết nối.
switchLatest thì chỉ nhận dữ liệu phát ra từ Observable cuối cùng tham gia vào.
reduce làm gọn lại tất cả các dữ liệu phát ra từ Observable bằng một luật tính toán nào đó. Khi Observable kết thúc thì sẽ nhận được kết quả. Ngoài ra, subscriber sẽ không nhận được bất kì giá trị nào khác.
scan tương tự như reduce. Nhưng subscriber sẽ nhận được kết quả ở từng bước tính toán khi
*/
