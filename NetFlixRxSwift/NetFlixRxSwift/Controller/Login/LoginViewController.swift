//
//  LoginViewController.swift
//  NetflixRxSwift
//
//  Created by MAC on 8/19/22.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var usernameTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextfield()
        
    }

    func setupTextfield(){
        usernameTextfield.becomeFirstResponder()
        usernameTextfield.delegate = self
        passwordTextfield.delegate = self
    }

    @IBAction func loginButton(_ sender: UIButton) {
        login()
    }
    

    func login(){
        let vc = MainTabBarViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
}

extension LoginViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTextfield {
            passwordTextfield.becomeFirstResponder()
        }
        if textField == passwordTextfield {
            login()
        }
        
        return false
    }
    
}
