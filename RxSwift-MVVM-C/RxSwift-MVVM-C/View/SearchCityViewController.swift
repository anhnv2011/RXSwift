//
//  SearchCityViewController.swift
//  RxSwift-MVVM-C
//
//  Created by Nguyen Viet Anh on 3/9/23.
//

import UIKit
import RxSwift
import RxDataSources

class SearchCityViewController: UIViewController {

    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var searchTextfiled: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: SearchCityViewPresentable! 
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
