import UIKit
import RxSwift
import RxCocoa


//MARK:- Ignoring operators
example(of: "ignoreElements") {
    let subject = PublishSubject<String>()
    let bag = DisposeBag()
    subject.ignoreElements().subscribe{ value in
        print(value)
        
    }
    .disposed(by: bag)
    
    subject.onNext("1")
    subject.onNext("2")
    subject.onNext("3")
    subject.onCompleted()
    
    /*
     --- Example of: ignoreElements ---
     completed
     
     CHỈ IN ra duy nhất oncomple. Nó skip tất cả
     */
}

example(of: "elementAt") {
    let subject = PublishSubject<String>()
    let bag = DisposeBag()
    
    subject
        .element(at: 2)
        .subscribe(onNext: { value in
            print(value)
        },
        onCompleted: {
            print("completed")
        }
        )
        .disposed(by: bag)
    
    subject.onNext("1")
    subject.onNext("2")
    subject.onNext("3")
    
   // subject.onCompleted()
    
    /*
     --- Example of: elementAt ---
     3
    Note: Khi toán tử elementAt này giúp bạn đạt được mục đích của nó, thì subscription sẽ tự động kết thúc. Không cần gọi subject.onCompleted()
     */
}

example(of: "filter") {
    let bag = DisposeBag()
       let array = Array(0...10)
       
       Observable.from(array)
           .filter { $0 % 2 == 0 }
           .subscribe(onNext: {
               print($0) })
           .disposed(by: bag)
    
    
    /*
     --- Example of: filter ---
     0
     2
     4
     6
     8
     10
     */
}


//MARK:- 2. Skip Operators

example(of: "skip(_:)") {
    let disposeBag = DisposeBag()
      
      Observable.of("A", "B", "C", "D", "E", "F")
          .skip(3) //Skip bao nhiêu phần tử
          .subscribe(onNext: {
              print($0) })
          .disposed(by: disposeBag)
    /*
     --- Example of: skip(_:) ---
     D
     E
     F

     */
}
example(of: "skipWhile") {
    let bag = DisposeBag()
      
      Observable.of(2, 4, 8, 9, 2, 4, 5, 7, 0, 10)
        .skip { $0 % 2 == 0 }
          .subscribe(onNext: {
              print($0) })
          .disposed(by: bag)
    /*
     --- Example of: skipWhile ---
     9
     2
     4
     5
     7
     0
     10
     gần giống filter
     nhưng nó sẽ skip các phần tử thoả mãn điều kiện cho đến khi gặp 1 phần tử ko thoả mãn.
     Lúc này nó sẽ in phần tử ko thoả mãn đó và  in phần còn lại bất kể có thoả mãn điều kiên hay ko

     */
}

example(of: "skipUntil") {
    //Toàn bộ toán tử trên là bạn đã lọc hoặc bỏ qua các phần tử với các kiều kiện tĩnh. Còn với skipUntil thì sẽ sử dụng một điều kiện động. Ở đây chính là dùng một observable khác để làm điều kiện.
    
    let bag = DisposeBag()
        
        let subject = PublishSubject<String>()
        let trigger = PublishSubject<String>()
        
        subject
            .skip(until: trigger)
            .subscribe(onNext: { value in
                print(value)
            })
            .disposed(by: bag)
        
        subject.onNext("1")
        subject.onNext("2")
        subject.onNext("3")
        subject.onNext("4")
        subject.onNext("5")
        
        trigger.onNext("XXX")
        
        subject.onNext("6")
        subject.onNext("7")
    /*
            --- Example of: skipUntil ---
            6
            7
    */
}


//MARK:- Taking Operators
//Take trái ngược với skip
example(of: "take") {
    let bag = DisposeBag()
      
      Observable.of(1, 2, 3, 4, 5, 6, 7, 8, 9)
          .take(4)
          .subscribe(onNext: { (value) in
              print(value)
          })
          .disposed(by: bag)
    
    /*
     Chỉ lấy số phần tử nhất đinh
     
     --- Example of: take ---
     1
     2
     3
     4

    */
}

example(of: "takeWhile") {
    let bag = DisposeBag()
      
      Observable.of(1, 2, 3, 4, 5, 6, 7, 8, 9)
        .take(while: { $0 < 4 })
          .subscribe(onNext: { (value) in
              print(value)
          })
          .disposed(by: bag)
    /*
     Ngược lại với skip thì nó chỉ lấy các phần tử thoả mãn điều kiện cho đến khi gặp phải điều kiện sai thfi nó sẽ tự động dừng lại và ko duyệt nữa
     
     ---- Example of: takeWhile ---
     1
     2
     3

    */
    
    
    //Chỉ duyệt 3 số đầu, và nếu nó chẵn thì in
    let bag2 = DisposeBag()
       
       Observable.of(2, 4, 6, 8, 0, 12, 1, 3, 4, 6, 2)
           .enumerated()
        .take(while: { (index, value) in
            index < 3 && value % 2 == 0
        })
           .subscribe(onNext: { (value) in
               print(value)
           })
           .disposed(by: bag2)
//    (index: 0, element: 2)
//    (index: 1, element: 4)
//    (index: 2, element: 6)

}

example(of: "takeUntil") {
    let bag = DisposeBag()
      
      let subject = PublishSubject<String>()
      let trigger = PublishSubject<String>()
      
      subject
        .take(until: trigger)
          .subscribe(onNext: { value in
              print(value)
          })
          .disposed(by: bag)
      
      subject.onNext("1")
      subject.onNext("2")
      subject.onNext("3")
      subject.onNext("4")
      subject.onNext("5")
      
      trigger.onNext("XXX")
      
      subject.onNext("6")
      subject.onNext("7")
    
    /*
     nhận được tất cả các giá trị trước khi trigger phát ra giá trị đầu tiên
     --- Example of: takeUntil ---
     1
     2
     3
     4
     5


    */
}



//MARK:- Distinct operators
example(of: "Equatable Type") {
    let disposeBag = DisposeBag()
       
       Observable.of("A", "A", "B", "B", "A", "A", "A", "C", "A")
           .distinctUntilChanged()
           .subscribe(onNext: {
               print($0)
               
           })
           .disposed(by: disposeBag)
    /*
     --- Example of: Equatable Type ---
     A
     B
     A
     C
     A

     Loại bỏ tất cả các phần tử trùng nhau liên tiếp, nhưng nếu cách nhau thi ko sao

    */
}

example(of:" Custom Type,") {
    struct Point {
          var x: Int
          var y: Int
      }
      
      let disposeBag = DisposeBag()
      
      let array = [ Point(x: 0, y: 1),
                    Point(x: 0, y: 2),
                    Point(x: 1, y: 0),
                    Point(x: 1, y: 1),
                    Point(x: 1, y: 3),
                    Point(x: 2, y: 1),
                    Point(x: 2, y: 2),
                    Point(x: 0, y: 0),
                    Point(x: 3, y: 3),
                    Point(x: 0, y: 1)]
      
      Observable.from(array)
          .distinctUntilChanged { (p1, p2) -> Bool in
              p1.x == p2.x
          }
          .subscribe(onNext: { point in
              print("Point (\(point.x), \(point.y))")
          })
          .disposed(by: disposeBag)
//        --- Example of:  Custom Type, ---
//        Point (0, 1)
//        Point (1, 0)
//        Point (2, 1)
//        Point (0, 0)
//        Point (3, 3)
//        Point (0, 1)

}
