//
//  HomeViewController.swift
//  NetflixRxSwift
//
//  Created by MAC on 8/19/22.
//

import UIKit
import RxCocoa
import RxSwift
class HomeViewController: UIViewController {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var trendingFilmTableView: UITableView!
    
    @IBOutlet weak var widthButtonViewConstraint: NSLayoutConstraint!
    var lastVelocityYSign = 0
    let bag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        trendingFilmTableView.rx.didScroll
//            .subscribe(onNext: { element in
////
//                print(element)
//                
//            }).dispose()
        
    }



}
extension HomeViewController: UITableViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentVelocityY =  scrollView.panGestureRecognizer.velocity(in: scrollView.superview).y
                let currentVelocityYSign = Int(currentVelocityY).signum()
                if currentVelocityYSign != lastVelocityYSign &&
                    currentVelocityYSign != 0 {
                    lastVelocityYSign = currentVelocityYSign
                }
                if self.lastVelocityYSign < 0 {

                    UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions(), animations: {
                        self.widthButtonViewConstraint.constant = 40

                    }, completion: nil)
                    //print("SCROLLING DOWN")
                } else if self.lastVelocityYSign > 0 {
                    UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions(), animations: {
                        self.widthButtonViewConstraint.constant = 200

                    }, completion: nil)
                   // print("SCOLLING UP")
                }
    }
}


