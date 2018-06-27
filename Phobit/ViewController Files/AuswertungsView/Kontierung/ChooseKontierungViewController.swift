//
//  ChooseKontierungViewController.swift
//  Phobit
//
//  Created by Paul Wiesinger on 19.02.18.
//  Copyright © 2018 Paul Wiesinger. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class ChooseKontierungViewController: UITableViewController {
    
    var konten: [String]?
    
    var delegate: EditingProtocol?
    
    let searchController = UISearchController.init(searchResultsController: nil)
    var blackView : UIView?
    
    
    @IBOutlet var newVerwendung: UIView!
    @IBOutlet weak var textField: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // setup the searchController
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Gib deinen Suchbegriff ein"
        
        
        blackView = UIView.init(frame: self.view.frame)
        blackView?.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(removeFromSuperview)))
        
        
        if #available(iOS 11.0, *) {
            self.navigationItem.searchController = searchController
            self.navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            // Fallback on earlier versions
        }
        
        self.definesPresentationContext = true
//            searchController.searchBar.tintColor = .white
        
        
            if #available(iOS 11.0, *) {
               
                let scb = searchController.searchBar
//                scb.tintColor = UIColor.white
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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(addVerwendungszweck))

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Zurück", style: .plain, target: self, action: #selector(returnHome))
        
        textField.returnKeyType = .done
        
    }
    
    @IBAction func enterPressed(_ sender: Any) {
        createNewVerwendungszweckEntry(verwendungszweck: textField.text!)
        removeFromSuperview()
        
    }
    
    @objc func removeFromSuperview(){
        UIView.animate(withDuration: 0.4) {
            self.newVerwendung.alpha = 0
            self.blackView?.alpha = 0
        }
        blackView?.removeFromSuperview()
        newVerwendung.removeFromSuperview()
    }
    
    @objc func addVerwendungszweck(){
        
        blackView?.backgroundColor = .black
        
        newVerwendung.center = (self.navigationController?.view.center)!
        newVerwendung.alpha = 0
        blackView?.alpha = 0
        
        self.navigationController?.view.addSubview(blackView!)
        self.navigationController?.view.addSubview(newVerwendung)
        
        
        UIView.animate(withDuration: 0.4) {
            self.newVerwendung.alpha = 1
            self.blackView?.alpha = 0.7
        }
        
        
    
        
        
    }
    
    func createNewVerwendungszweckEntry(verwendungszweck : String){
        if(verwendungszweck == nil || verwendungszweck == ""){
            return
        }
        var array = UserDefaults.standard.array(forKey: "verwendung") as? [String] ?? []
        if(!array.isEmpty){
            array.append(verwendungszweck)
            UserDefaults.standard.set(array, forKey: "verwendung")
        }
        else{
            print("could not add verwendungszweck! Line 94: ChooseKontierungViewController")
        }
        
        
    
        prepareData()
        sortTableView()
        tableView.reloadData()
        
        searchController.isActive = false
        
        
        let kontobezeichnung = verwendungszweck
        
        self.dismiss(animated: true) {
            self.delegate?.userDidEdit(inIndexPath: IndexPath.init(row: 0, section: 3), changedText: "\(kontobezeichnung ?? "Fehler")")
        }
        

        
    }
    
    private func sortTableView(){
        konten?.sort()
        tableView.reloadData()
        
        
    }
    

    
    
    private func prepareData() {
        if(UserDefaults.standard.array(forKey: "verwendung") == nil){


            
            if let path = Bundle.main.path(forResource: "PhobitKontenplan", ofType: "csv") {
                do {
                    let data = try String(contentsOfFile: path, encoding: .utf8)
                    konten = data.components(separatedBy: .newlines)
                } catch {
                    print("Something went wrong in line 134: ChooseKontierungViewController \(error)")
                }
                konten?.removeLast()
                sortTableView()
                UserDefaults.standard.set(konten, forKey: "verwendung")
                
                
            }
            
            
        }else{
            
            
                konten = UserDefaults.standard.array(forKey: "verwendung") as? [String]
                sortTableView()

            
    
       
        }
    }
    
    func deleteCell(cellToDelete: String){
        var array = UserDefaults.standard.array(forKey: "verwendung") as? [String]
        
        
        var count = 0;
        for string in array!{
            if(string.elementsEqual(cellToDelete)){
                array!.remove(at: count)
                break;
            }
            count=count+1;
        }
        UserDefaults.standard.set(array, forKey: "verwendung")
        konten = array
        sortTableView()
        tableView.reloadData()
    }
    
    @objc private func returnHome() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        let cell = tableView.cellForRow(at: indexPath) as! KontierungTableViewCell
        
        
        // otherwise the animatioin of the searchbar would crash the dismiss of the view.
        searchController.isActive = false
        
        
        let kontobezeichnung = cell.kontobezeichnung.text
        
        self.dismiss(animated: true) {
            self.delegate?.userDidEdit(inIndexPath: IndexPath.init(row: 0, section: 3), changedText: "\(kontobezeichnung ?? "Fehler")")
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
            cell.leftButtons = [MGSwipeButton(title: "Löschen", backgroundColor: .red) {
                (sender: MGSwipeTableCell!) -> Bool in
                self.deleteCell(cellToDelete: cell.kontobezeichnung.text!)
                return true
                
                }]
            cell.leftSwipeSettings.transition = .drag
            let setting = MGSwipeExpansionSettings.init()
            setting.buttonIndex = 0
            setting.fillOnTrigger = true
            setting.threshold = 1.5
            cell.leftExpansion = setting
            cell.kontobezeichnung.text = konten[indexPath.row]
            
            
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
            tableView.reloadData()
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


