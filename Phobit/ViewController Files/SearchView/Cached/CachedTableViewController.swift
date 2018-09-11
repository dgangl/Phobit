//
//  CachedTableViewController.swift
//  Phobit
//
//  Created by Paul Wiesinger on 10.09.18.
//  Copyright © 2018 LonoS. All rights reserved.
//

import UIKit

class CachedTableViewController: UITableViewController {

    var billData = [BillData2]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        // Snap View controller
        NotificationCenter.default.addObserver(self, selector: #selector(appears), name: NSNotification.Name(rawValue: AppearDisappearManager.getAppearString(id: 0)), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(disappears), name: NSNotification.Name(rawValue: AppearDisappearManager.getDisappearString(id: 0)), object: nil)
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = title
        
        self.navigationItem.rightBarButtonItems =  [UIBarButtonItem.init(barButtonSystemItem: .camera, target: self, action: #selector(pageBack)), UIBarButtonItem.init(title: "Zurück", style: .plain, target: self, action: #selector(pageBack))]
        
        DispatchQueue.main.async {
            if let data = LokaleAblage().read() {
                self.billData = data
                self.tableView.reloadData()
            }
        }
    }

    @objc func pageBack(){
        AppDelegate.snapContainer.scrollToPage(1)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return billData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AblageTableViewCell
        
        let bill = billData[indexPath.row]
        cell.firmenname.text = bill.rechnungsersteller
        cell.betrag.text = CFormat.correctGeldbetrag(zahl: String(bill.gesamtBrutto))
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        performSegue(withIdentifier: "showDetail", sender: billData[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let vc = segue.destination as! AuswertungsTableViewController
            vc.bill = sender as? BillData2
            vc.isDetail = true
        }
    }
    
    @objc func appears() {
        
    }

    @objc func disappears() {
        
    }
}
