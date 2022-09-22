//
//  CocktailViewController.swift
//  DemoRxSwift
//
//  Created by MAC on 8/15/22.
//

import UIKit
import RxCocoa
import RxSwift

class CocktailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let bag = DisposeBag()
    let categories = BehaviorRelay<[CocktailCategory]>(value: [])
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configTable()
        categories.asObservable().subscribe(onNext: { [weak self] _ in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
            
        },
        onError: { error in
            print(error.localizedDescription)
            
        },
        onCompleted: {},
        onDisposed: {})
        .disposed(by: bag)
        
        loadAPI()
    }
    
    func configTable(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    func loadAPI() {
        let newCategories = Networking.shared.getCategories(kind: "c")
        
        newCategories
            .bind(to: categories)
            .disposed(by: bag)
    }
    
    
}
extension CocktailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.value.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let item = categories.value[indexPath.row]
        cell.textLabel?.text = "\(item.strCategory) - \(item.items.count) items"
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
           let item = categories.value[indexPath.row]
           print("\(item.strCategory) - \(item.items.count) items")
           
           let vc = DrinksViewController()
           vc.categoryName = item.strCategory
           self.navigationController?.pushViewController(vc, animated: true)
    }
}
