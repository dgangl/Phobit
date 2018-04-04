//
//  ChooseKontierungViewController.swift
//  Phobit
//
//  Created by Paul Wiesinger on 19.02.18.
//  Copyright © 2018 Paul Wiesinger. All rights reserved.
//

import UIKit

class ChooseKontierungViewController: UITableViewController {
    
    var konten: [String]?
    
    var delegate: EditingProtocol?
    
    let searchController = UISearchController.init(searchResultsController: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // setup the searchController
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Geben Sie Ihren Suchbegriff ein"
        
        
        if #available(iOS 11.0, *) {
            self.navigationItem.searchController = searchController
            self.navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            // Fallback on earlier versions
        }
        
        self.definesPresentationContext = true
            searchController.searchBar.tintColor = .white
            
            
            if #available(iOS 11.0, *) {
               
                let scb = searchController.searchBar
                scb.tintColor = UIColor.white
                scb.barTintColor = UIColor.white
                
                if let textfield = scb.value(forKey: "searchField") as? UITextField {
                    textfield.textColor = UIColor.lightGray
                    if let backgroundview = textfield.subviews.first {
                        
                        // Background color
                        backgroundview.backgroundColor = UIColor.white
                        
                        // Rounded corner
                        backgroundview.layer.cornerRadius = 10;
                        backgroundview.clipsToBounds = true;
                    }
                }
                
                
                navigationItem.searchController = searchController
                navigationItem.hidesSearchBarWhenScrolling = false
            
            
        }
        
        prepareData()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Zurück", style: .plain, target: self, action: #selector(returnHome))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private func prepareData() {
        if let path = Bundle.main.path(forResource: "PhobitKontenplan", ofType: "csv") {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                konten = data.components(separatedBy: .newlines)
            } catch {
                print(error)
            }
            konten?.removeLast()
        }
    }
    
    @objc private func returnHome() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // otherwise the animatioin of the searchbar would crash the dismiss of the view.
        searchController.isActive = false
        
        let cell = tableView.cellForRow(at: indexPath) as! KontierungTableViewCell
        
        
        self.dismiss(animated: true) {
            self.delegate?.userDidEdit(inIndexPath: IndexPath.init(row: 0, section: 3), changedText: "\(cell.kontonummer.text ?? "Fehler") \(cell.kontobezeichnung.text ?? "Fehler")")
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let konten = konten {
            return konten.count
        } else {
            return 0
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let konten = konten {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! KontierungTableViewCell
            
            let itemsArr = konten[indexPath.row].components(separatedBy: ";")
            
            
            cell.kontonummer.text = itemsArr[0]
            cell.kontobezeichnung.text = itemsArr[1]
            
            
            return cell
        } else {
            return tableView.dequeueReusableCell(withIdentifier: "cell") as! KontierungTableViewCell
        }
        
        
    }
    
    
  
}



extension ChooseKontierungViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        prepareData()
        
        if searchController.searchBar.text == "" {
            return
        } else {
            
            
            var sorted = [String]()
            _ = konten?.map({ (string) -> Void in
                if string.localizedCaseInsensitiveContains(searchController.searchBar.text!) {
                    sorted.append(string)
                }
            })
            
            konten = sorted
        }
        
        tableView.reloadData()
    }
    
    
}
