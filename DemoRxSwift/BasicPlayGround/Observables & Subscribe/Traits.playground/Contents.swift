import UIKit
import RxSwift

//https://fxstudio.dev/rxswift-traits/
/*
Các đặc điểm của Trait bao gồm:

Nó không xảy ra lỗi.
Trait được observe và subscribe trên MainScheduler.
Trait không chia sẻ Side Effect. (một số loại khác sẽ có)
Side Effect là những thay đổi phía bên ngoài của một scope (khối lệnh). Trong RxSwift, Side Effect được dùng để thực hiện một tác vụ nào đó nằm bên ngoài của scope mà không làm ảnh hưởng tới scope đó.
*/


//MARK:- Single

/*
 Single là một biến thể của Observable trong RxSwift.
 Thay vì emit được ra một chuỗi các element như Observable thì Single sẽ chỉ emit ra duy nhất một element hoặc một error.
 Không chia sẻ Side Effect.
 */
example(of: "Single") {
    
    enum FileError: Error {
        case pathError
    }
    
    let bag = DisposeBag()
    
    func readFile(path: String?) -> Single<String> {
        return Single.create { single -> Disposable in
            if let path = path  {
                single(.success("Succeass!"))
            } else {
                single(.failure(FileError.pathError))
            }
            
            return Disposables.create()
        }
    }
    
    readFile(path: nil)
        .subscribe { event in
            switch event {
            case .success(let value):
                print(value)
            case .failure(let error):
                print(error)
            }
    }
    .disposed(by: bag)
    
    readFile(path: "ádasdasdasd")
        .subscribe { event in
            switch event {
            case .success(let value):
                print(value)
            case .failure(let error):
                print(error)
            }
    }
    .disposed(by: bag)
}




print("--------------------------------------------------------------------------")
//MARK:- Completable
/*
 Giống với Single, Completable cũng là một biến thể của Observable.
 Điểm khác biệt của Completable so với Single, đó là nó chỉ có thể emit ra một error hoặc chỉ complete (không emit ra event mà chỉ terminate).
 Không chia sẻ Side Effect.
 */
example(of: "Completable") {
    let bag = DisposeBag()
    
    enum FileError: Error {
        case pathError
        case failedCaching
    }
    
    func cacheLocally() -> Completable {
        return Completable.create { completable in
            // Store some data locally
            //...
            //...
            
            let success = true
            
            guard success else {
                completable(.error(FileError.failedCaching))
                return Disposables.create {}
            }
            
            completable(.completed)
            return Disposables.create {}
        }
    }
    
    cacheLocally()
        .subscribe { completable in
            switch completable {
            case .completed:
                print("Completed with no error")
            case .error(let error):
                print("Completed with an error: \(error)")
            }
    }
    .disposed(by: bag)
    
    cacheLocally()
        .subscribe(onCompleted: {
            print("Completed with no error")
        },
                   onError: { error in
                    print("Completed with an error: \(error)")
        })
        .disposed(by: bag)
}




print("--------------------------------------------------------------------------")
//MARK:- Maybe
/*
 Maybe cũng là một biến thể của Observable và là sự kết hợp giữa Single và Completable.
 Nó có thể emit một element, complete mà không emit ra element hoặc emit ra một error.
 Đặc điểm của Maybe:

 Có thể phát ra duy nhất một element, phát ra một error hoặc cũng có thể không phát ra bất cứ event nào và chỉ complete.
 Sau khi thực hiện bất kỳ 1 trong 3 sự kiện nêu trên thì Maybe cũng sẽ terminate.
 Không chia sẻ Side Effect.
 */
example(of: "Maybe") {
    
    let bag = DisposeBag()
    
    enum MyError: Error {
        case anError
    }
    
    func generateString() -> Maybe<String> {
        return Maybe<String>.create { maybe in
            maybe(.success("RxSwift"))
            
            // OR
            
            maybe(.completed)
            
            // OR
            
            maybe(.error(MyError.anError))
            
            return Disposables.create {}
        }
    }
    
    generateString()
        .subscribe { maybe in
            switch maybe {
            case .success(let element):
                print("Completed with element \(element)")
            case .completed:
                print("Completed with no element")
            case .error(let error):
                print("Completed with an error \(error.localizedDescription)")
            }
    }
    .disposed(by: bag)
    
    generateString()
        .subscribe(onSuccess: { element in
            print("Completed with element \(element)")
        }, onError: { error in
            print("Completed with an error \(error.localizedDescription)")
        }, onCompleted: {
            print("Completed with no element")
        })
        .disposed(by: bag)
}




print("--------------------------------------------------------------------------")
example(of: ".asSingle() and .asMaybe()") {
    let observable = Observable<String>.of("k", "l", "M", "D", "E", "F").asSingle()
    observable.subscribe { event in
       
        switch event {
        case .success(let success):
            print(success)
        case .failure(let error):
            print(error.localizedDescription)
            print("Because have manny element")
    
        }
        
        
    }
}
