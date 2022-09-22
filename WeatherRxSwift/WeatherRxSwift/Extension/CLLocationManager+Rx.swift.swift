//
//  CLLocationManager+Rx.swift.swift
//  WeatherRxSwift
//
//  Created by MAC on 8/17/22.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit
import CoreLocation

//báo cho rx biết CLLocationManager có delegate
extension CLLocationManager: HasDelegate{
    public typealias locationDelegate = CLLocationManagerDelegate
}
class  RxCLLocationManagerDelegateProxy: DelegateProxy<CLLocationManager, CLLocationManagerDelegate>, DelegateProxyType, CLLocationManagerDelegate {
    
    
    // properties --> Cocoa class
    weak public private(set) var locationManager: CLLocationManager?
    
    // init
    public init(locationManager: ParentObject) {
        self.locationManager = locationManager
        super.init(parentObject: locationManager, delegateProxy: RxCLLocationManagerDelegateProxy.self)
        
//        ParentObject nó chính là Base và cũng là CLLocationManager trong ví dụ của chúng ta.
//        Sau đó gán thuộc tính với tạo với tham số ParentObject
//        Cuối cùng gọi super.init để hoàn thiện việc khởi tạo
    }
    static func registerKnownImplementations() {
        self.register { RxCLLocationManagerDelegateProxy(locationManager: $0) }
    }
    
}
    

public extension Reactive where Base: CLLocationManager {
    //delegateProxy
    var delegateCustom : DelegateProxy<CLLocationManager, CLLocationManagerDelegate> {
            return RxCLLocationManagerDelegateProxy.proxy(for: base)
        }
    var didUpdateLocation: Observable<[CLLocation]>{
        return delegateCustom.methodInvoked(#selector(CLLocationManagerDelegate.locationManager(_:didUpdateLocations:)))
            .map({parameter in
                return parameter[1] as! [CLLocation]
            })
        
//        didUpdateLocation là một Observable với kiểu giá trị trả về là một Array CLLocation
//        Sử dụng chính Delegate Proxy bằng việc dùng method methodInvoked. Nó như một lời mời gọi function của CLLocationManagerDelegate mà ta đã chọn ở trên.
//        Vì là của Objective-C nên bạn sử dụng #selector và cung cấp đúng function đã chọn
//        Kết quả trả về sẽ là 1 Observable với kiểu như thế này Observable<[Any]> Trong đó [Any] là một mãng được tạo từ các tham số trong function của CLLocationManagerDelegate.
//        Cuối cùng ta dùng map để đưa [Any] thành [CLLocation]. Tất nhiên là không thể được ngay lập tức. Vì function của CLLocationManagerDelegate có tới 2 tham số.
//        Xác định từ trước thì tham số thứ 2 parameters[1] sẽ là [CLLocation]. Nên chỉ việc return nó trong map là xong.
    }
}
