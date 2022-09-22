//
//  DrinksViewController.swift
//  DemoRxSwift
//
//  Created by MAC on 8/15/22.
//

import UIKit
import RxSwift
import RxCocoa
class DrinksViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var bag = DisposeBag()
    let drinks = BehaviorRelay<[Drink]>(value: [])
    var categoryName = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configTable()
        drinks.asObservable()
            .subscribe(onNext: { _ in
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }, onError: { error in
                print(error.localizedDescription)
            }, onCompleted: {}, onDisposed: {})
            .disposed(by: bag)
        
        loadAPI()
    }
    
    func loadAPI() {
        Networking.shared.getDrinks(kind: "c", value: categoryName)
            .bind(to: drinks)
            .disposed(by: bag)
    }
    func configTable(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "DrinkCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
    
}
extension DrinksViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        drinks.value.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DrinkCell
        
        
        let item = drinks.value[indexPath.row]
        cell.nameLabel.text = item.strDrink
        cell.thumbnailImageView.kf.setImage(with: URL(string: item.strDrinkThumb)!)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200
    }
}
