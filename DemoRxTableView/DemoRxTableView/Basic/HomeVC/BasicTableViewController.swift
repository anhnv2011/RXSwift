//
//  BasicTableViewController.swift
//  DemoRxTableView
//
//  Created by MAC on 8/18/22.
//

import UIKit
import RxSwift
import RxCocoa

struct User {
    let firstname: String
    let lastname : String
}

class BasicTableViewController: UIViewController, UIScrollViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    private var bag = DisposeBag()
    private var cities = ["Hà Nội","Hải Phòng", "Vinh", "Huế", "Đà Nẵng", "Nha Trang", "Đà Lạt", "Vũng Tàu", "Hồ Chí Minh"]
    var users = [
        User(firstname: "anh", lastname: "nguyen"),
        User(firstname: "long", lastname: "tran")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "City"
        configTableView()
    }
    
    func configTableView(){
        // register cell
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        // create observable
        let observable = Observable.of(cities)
        
        // bind to tableview
        observable.bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)){index, element, cell in
            cell.textLabel?.text = element
        }
        .disposed(by: bag)
        /*
         Chúng ta sẽ biến đổi Array String cities thành một Observable, bằng toán tử of
         Vì là một Observable rồi, nên ta có thể bind từng phần tử lên thuộc tính items trong không gian .rx của TableView (cái này có trong RxCocoa).
         Các tham số của phương thước bind chính là identifier cho cell. Nên đảm bảo việc reusable thì bạn cần register cell trước.
         
         */
        
        tableView.rx.modelSelected(String.self)
            .subscribe(onNext: { value in
               // print(value)
            })
            .disposed(by: bag)
        
        
        tableView.rx
            .itemDeselected
            .subscribe(onNext: { indexPath in
               // print("Deselected with indextPath: \(indexPath)")
            })
            .disposed(by: bag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { indexPath in
                self.tableView.deselectRow(at: indexPath, animated: true)
                //print(indexPath)
                
            })
            .disposed(by: bag)
        
        Observable
            .zip(tableView.rx.itemSelected, tableView.rx.modelSelected(String.self))
            .bind { [unowned self] indexPath, model in
                self.tableView.deselectRow(at: indexPath, animated: true)
                print("Selected " + model + " at \(indexPath)")
            }
            .disposed(by: bag)
    
    
        //Dùng các deleget của swift
        
        tableView.rx.setDelegate(self)
            .disposed(by: bag)
    
    }

}
extension BasicTableViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            print("Did selected TableView with \(indexPath)")
        }
}
