//
//  DetailTableViewController.swift
//  Phobit
//
//  Created by Lonos on 09.12.17.
//  Copyright © 2017 Lonos. All rights reserved.
//

import UIKit

class DetailTableViewController: UITableViewController {
    
    private let sections = ["Rechnungsersteller", "Belegdaten", "Steuersätze", "Kontierungsvorschlag", "Bezahlung"]
    
    var senderObject: BillData?
    
    private var dataArray = [Item]()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let senderObject = senderObject {
            print(senderObject.getRechnungsersteller() + senderObject.getDatum())
            
            
            self.title = "Detailansicht"
            
            dataArray = senderObject.getTableViewArray()
        }
        
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    
    //    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0, 3, 4:
            return 1
        case 1:
            return 3
        case 2:
            return senderObject!.getAnzahlSteuersätze()
            
        default:
            print("error in tableView numberOfRowsInSection, with section: \(section)")
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let numberOfRows = aufsummieren(indexPath: indexPath)
        
        let item = dataArray[numberOfRows]
        
        if let descr = item.description {
            // two items
            let cell = tableView.dequeueReusableCell(withIdentifier: "twoItem") as! TwoItemsCell
            
            cell.rightItem.text = descr
            cell.leftItem.text = item.value
            
            return cell
        } else {
            // one item
            let cell = tableView.dequeueReusableCell(withIdentifier: "oneItem") as! TextCell
            
            cell.textField.text = item.value
            
            return cell
        }
    }
    
    
    private func aufsummieren(indexPath: IndexPath) -> Int {
        var numberOfRows = 0
        
        for number in 0..<indexPath.section {
            numberOfRows += tableView.numberOfRows(inSection: number)
        }
        
        numberOfRows += indexPath.row
        
        return numberOfRows
    }
}

