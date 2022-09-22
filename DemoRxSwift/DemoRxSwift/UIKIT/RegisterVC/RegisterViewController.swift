//
//  RegisterViewController.swift
//  DemoRxSwift
//
//  Created by MAC on 8/1/22.
//

import UIKit
import RxSwift
import RxCocoa
class RegisterViewController: UIViewController {
    // MARK: Outlets
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    private let bag = DisposeBag()
    private let image = BehaviorRelay<UIImage?>(value: nil)
    //    Tại sao là Relay , vì:
    //    Nó không bao giờ kết thúc
    //    Dữ liệu của nó sẽ liên quan tới dữ liệu của một UI Control trong View
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Register"
        configUI()
        
        
        image
            .subscribe(onNext: { img in
                self.avatarImageView.image = img
            })
            .disposed(by: bag)
    }
    
    
    func configUI(){
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.height/2
        avatarImageView.layer.borderWidth = 5
        avatarImageView.layer.borderColor = UIColor.red.cgColor
        avatarImageView.layer.masksToBounds = true
        
        
        avatarImageView.isUserInteractionEnabled  = true
        let tapImage = UITapGestureRecognizer(target: self, action: #selector(tapChangeImage))
        avatarImageView.addGestureRecognizer(tapImage)
    }
    
    @objc func tapChangeImage(){
//                print("asdadad")
//                let img = UIImage(named: "avartar")
//                image.accept(img)
        let vc = ChangeAvatarViewController()
        navigationController?.pushViewController(vc, animated: true)
        vc.selectPhoto.subscribe(onNext: { img in
            print(img)
            self.image.accept(img)

        },
        onError: { error in
            print(error.localizedDescription)

        },
        onCompleted: {
            print("da hoan thanh chon avarta")

        },
        onDisposed: {
            print("da hoan thanhf dispose avartar")
        }).disposed(by: bag)
        
    }
    
    func registerButton1(){
        RegisterModel.shared.register(username: usernameTextField.text,
                                      password: passwordTextField.text,
                                      email: emailTextField.text,
                                      avatar: avatarImageView.image)
            .subscribe(onNext: {element in
                print("Register successful", element)
            },onError: {error in
                if let myError = error as? APIError {
                    print(myError.localizedDescription)
                }
            },onCompleted: {
                print("Register Complete")
            },onDisposed: {
                print("Disposed register")
            })
            .disposed(by: bag)
    }
    
    func registerButton2(){
        RegisterModel.shared.register2(username: usernameTextField.text,
                                       password: passwordTextField.text,
                                       email: emailTextField.text,
                                       avatar: avatarImageView.image)
            .subscribe(onSuccess: { succes in
                print("Single register succes", succes)
            },onFailure: {error in
                if let myerror = error as? APIError {
                    print(myerror.localizedDescription)
                }
            }, onDisposed: {
                print("Single register dispose")
            })
            .disposed(by: bag)
    }
    @IBAction func actionButton(_ sender: UIButton) {
        switch sender {
        case registerButton:
            print("reg")
            //registerButton1()
            registerButton2()
            
            
            
        case clearButton:
            print("Clear")
        default:
            print("")
        }
    }
    
}
