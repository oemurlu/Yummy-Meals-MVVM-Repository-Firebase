//
//  PopOverSortingViewController.swift
//  Food-Order-App
//
//  Created by Osman Emre Ömürlü on 14.12.2023.
//

import UIKit

enum FilterBy {
    case ascending
    case descending
    case aToZ
    case zToA
}

protocol PopOverSortingDelegate: AnyObject {
    func filterCellDidSelect(filterBy: FilterBy)
}

class PopOverSortingViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    weak var delegate: PopOverSortingDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "FilterCell", bundle: nil), forCellReuseIdentifier: "filterCell")
        
        tableView.alwaysBounceVertical = false;
    }
}

extension PopOverSortingViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Filter by"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "filterCell", for: indexPath) as! FilterCell
        var cellText = cell.label.text
        switch indexPath.row {
        case 0: cellText = "Price: Ascending"
        case 1: cellText = "Price: Descending"
        case 2: cellText = "Name: A-Z"
        case 3: cellText = "Name: Z-A"
        default: cellText = ""
        }
        
        cell.label.text = cellText
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0: delegate?.filterCellDidSelect(filterBy: .ascending)
        case 1: delegate?.filterCellDidSelect(filterBy: .descending)
        case 2: delegate?.filterCellDidSelect(filterBy: .aToZ)
        case 3: delegate?.filterCellDidSelect(filterBy: .zToA)
        default: break;
        }
        
        DispatchQueue.main.async {
            self.tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
