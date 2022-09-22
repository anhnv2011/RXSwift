//
//  DynamicTableviewViewController.swift
//  DemoRxTableView
//
//  Created by MAC on 8/18/22.
//

import UIKit

class DynamicTableviewViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        let addButton = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(addNewItem))
        self.navigationItem.rightBarButtonItem = addButton
        let editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editItems))
        self.navigationItem.leftBarButtonItem = editButton
    }


    @objc func addNewItem() {
        // ...
    }
    @objc func editItems() {
        let editMode = tableView.isEditing
        tableView.setEditing(!editMode, animated: true)
    }

}
