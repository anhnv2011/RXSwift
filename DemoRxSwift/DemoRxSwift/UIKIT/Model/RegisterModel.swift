//
//  RegisterModel.swift
//  DemoRxSwift
//
//  Created by MAC on 8/2/22.
//

import Foundation
import UIKit
import RxSwift
enum APIError: Error {
    case error(String)
    case errorURL
    
    var localizedDescription: String {
        switch self {
        case .error(let string):
            return string
        case .errorURL:
            return "URL String is error."
        }
    }
}

class RegisterModel{
    static let shared = RegisterModel()
    private init(){}
    
    
    
    func register(username: String?, password: String?, email: String?, avatar: UIImage?) -> Observable<Bool> {
        //
        return Observable.create { observer in
            // check params
            // username
            if let username = username {
                if username == "" {
                    observer.onError(APIError.error("username is empty"))
                }
            } else {
                observer.onError(APIError.error("username is nil"))
            }
            
            // password
            if let password = password {
                if password == "" {
                    observer.onError(APIError.error("password is empty"))
                }
            } else {
                observer.onError(APIError.error("password is nil"))
            }
            
            // email
            if let email = email {
                if email == "" {
                    observer.onError(APIError.error("email is empty"))
                }
            } else {
                observer.onError(APIError.error("email is nil"))
            }
            
            // avatar
            if avatar == nil {
                observer.onError(APIError.error("avatar is empty"))
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                observer.onNext((true))
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func register2(username: String?, password: String?, email: String?, avatar: UIImage?) -> Single<Bool> {
        return Single.create { (single) -> Disposable in
            // check params
            // username
            if let username = username {
                if username == "" {
                    single(.failure(APIError.error("username is empty")))
                }
            } else {
                single(.failure(APIError.error("username is nil")))
            }
            
            // password
            if let password = password {
                if password == "" {
                    single(.failure(APIError.error("password is empty")))
                }
            } else {
                single(.failure(APIError.error("password is nil")))
            }
            
            // email
            if let email = email {
                if email == "" {
                    single(.failure(APIError.error("email is empty")))
                }
            } else {
                single(.failure(APIError.error("email is nil")))
            }
            
            // avatar
            if avatar == nil {
                single(.failure(APIError.error("avatar is empty")))
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                single(.success(true))
            }
            
            return Disposables.create()
        }
    }
}
