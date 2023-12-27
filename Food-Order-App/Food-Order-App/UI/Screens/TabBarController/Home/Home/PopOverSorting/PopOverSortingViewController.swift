//
//  PopOverSortingViewController.swift
//  Food-Order-App
//
//  Created by Osman Emre Ömürlü on 14.12.2023.
//

import UIKit

enum FilterBy {
    case todaysOffers
    case ascending
    case descending
    case aToZ
    case zToA
}

protocol PopOverSortingDelegate: AnyObject {
    func filterCellDidSelect(filterBy: FilterBy)
}

final class PopOverSortingViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
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
        tableView.isScrollEnabled = false
        
    }
}

extension PopOverSortingViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Order by"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 45    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "filterCell", for: indexPath) as! FilterCell
        var cellText = cell.label.text
        switch indexPath.row {
        case 0: cellText = "Today's Offers!"
        case 1: cellText = "Price: Ascending"
        case 2: cellText = "Price: Descending"
        case 3: cellText = "Name: A-Z"
        case 4: cellText = "Name: Z-A"
        default: cellText = ""
        }
        
        cell.label.text = cellText
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
        switch indexPath.row {
        case 0: self.delegate?.filterCellDidSelect(filterBy: .todaysOffers)
        case 1: self.delegate?.filterCellDidSelect(filterBy: .ascending)
        case 2: self.delegate?.filterCellDidSelect(filterBy: .descending)
        case 3: self.delegate?.filterCellDidSelect(filterBy: .aToZ)
        case 4: self.delegate?.filterCellDidSelect(filterBy: .zToA)
        default: break;
        }
            self.tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
