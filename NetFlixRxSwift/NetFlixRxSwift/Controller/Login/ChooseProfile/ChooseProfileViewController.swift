//
//  ChooseProfileViewController.swift
//  NetflixRxSwift
//
//  Created by MAC on 8/19/22.
//

import UIKit

class ChooseProfileViewController: UIViewController {
    //image outlet
    @IBOutlet weak var user1Avartar: UIImageView!
    @IBOutlet weak var user2Avartar: UIImageView!
    @IBOutlet weak var user3Avartar: UIImageView!
    @IBOutlet weak var user4Avartar: UIImageView!
    
    //button outlet
    @IBOutlet weak var user1Button: UIButton!
    @IBOutlet weak var user2Button: UIButton!
    @IBOutlet weak var user3Button: UIButton!
    @IBOutlet weak var user4Button: UIButton!
  
    //view Outlet
    @IBOutlet weak var user1View: UIView!
    @IBOutlet weak var user2View: UIView!
    @IBOutlet weak var user3View: UIView!
    @IBOutlet weak var user4View: UIView!
    
    //MARK:- Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUserView()
    }


    func setupUserView(){
        user1View.layer.borderWidth = 2
        user1View.layer.borderColor = UIColor.white.cgColor
        user1View.layer.cornerRadius = 12
        
        user2View.layer.borderWidth = 2
        user2View.layer.borderColor = UIColor.white.cgColor
        user2View.layer.cornerRadius = 12

        user3View.layer.borderWidth = 2
        user3View.layer.borderColor = UIColor.white.cgColor
        user3View.layer.cornerRadius = 12

        
        user4View.layer.borderWidth = 2
        user4View.layer.borderColor = UIColor.white.cgColor
        user4View.layer.cornerRadius = 12

    }
    
    
    @IBAction func chooseProfileButton(_ sender: UIButton) {
        switch sender {
        case user1Button:
            let vc = MainTabBarViewController()
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        case user2Button:
            let vc = LoginViewController()
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        case user3Button:
            let vc = LoginViewController()
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        case user4Button:
            let vc = LoginViewController()
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
            
        default:
            print("")
        }
    }
    

}
