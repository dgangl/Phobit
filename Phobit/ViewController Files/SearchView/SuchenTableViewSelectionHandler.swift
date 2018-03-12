//
// SuchenTableViewSelectionHandler.swift
//  Phobit
//
//  Created by Paul Wiesinger on 25.02.18.
//  Copyright © 2018 Paul Wiesinger. All rights reserved.
//

import UIKit


extension SuchenTableViewController {
    
    // handle selections.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchController.isActive && searchController.searchBar.text != "" {
            guard let dataMasterArray = dataMaster?.searchedbilldata else {return}
            
            let searchBill = dataMasterArray[indexPath.row]
            self.performSegue(withIdentifier: "showDetail", sender: searchBill)
            
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        
        let bill = dataMaster?.getBillDataForCell(indexPath: indexPath)
        
        
        
        
        self.performSegue(withIdentifier: "showDetail", sender: bill)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let vc = segue.destination as! AuswertungsTableViewController
            vc.bill = sender as? BillData2
            vc.isDetail = true
        }
    }
}
