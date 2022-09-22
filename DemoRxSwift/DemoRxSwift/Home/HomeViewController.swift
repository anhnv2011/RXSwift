//
//  HomeViewController.swift
//  DemoRxSwift
//
//  Created by MAC on 7/29/22.
//

import UIKit
import RxSwift


class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let names = ["Register",
                 "Fetching Data",
                 "Networking Model",
                 "RxCocoa"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        let sequence = 0..<3
        //        var iterator = sequence.makeIterator()
        //        while let n = iterator.next() {
        //            print(n)
        //        }
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        
    }
    
    
}
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = names[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0 :
            let vc = RegisterViewController()
            navigationController?.pushViewController(vc, animated: true)
        case 1 :
            let vc = MusicListViewController()
            navigationController?.pushViewController(vc, animated: true)
        case 2 :
            let vc = CocktailViewController()
            navigationController?.pushViewController(vc, animated: true)
            
        case 3 :
            print("")
        default:
            print("")
        }
    }
    
}
