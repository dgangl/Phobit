//
//  SuchenTableViewController.swift
//  Phobit
//
//  Created by LonoS on 09.12.17.
//  Copyright © 2017 LonoS. All rights reserved.
//

import UIKit

//class SuchenTableViewController: UITableViewController {
//
////    dummy data
////    var samplefirmen = ["RZL Software", "Hofer KG", "Apple Inc.", "Microsoft", "Mediamarkt", "Saturn", "HTBLA Grieskirchen", "Maxi-Markt", "Libro"]
////    var sampleBeträge = ["12 €", "344,99€", "10.000,00 €", "99,99 €", "45,50 €", "15,00 €", "344,00 €","74,97 €", "3,99 €"]
////    var sampleDatum = ["31.12.2017", "24.12.2017", "22.12.2017", "13.12.2017"]
//
//
//    // array for the dates in descending order
//    var daten = [String]()
//
//
//    // object where the cell data is stored
//    var searchobject: SearchObject?
//    var input = Input()
//
//    // dict where the raw memory data is stored
//    var BillDataDictionary: [Int : [String]]?
//
//
//
//    // handle filtering
//    var isFiltering = false
//    var filteredSearchObject: FilterObject?
//    var foundSth = false
//    let searchController = UISearchController(searchResultsController: nil)
//
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.navigationController?.isNavigationBarHidden = false
//        self.navigationController?.navigationBar.prefersLargeTitles = true
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.navigationController?.isNavigationBarHidden = false
//
//        self.navigationController?.navigationBar.prefersLargeTitles = true
//
//        // setup the searchController
//        searchController.searchResultsUpdater = self
//        searchController.obscuresBackgroundDuringPresentation = false
//        searchController.searchBar.placeholder = "Geben Sie Ihren Suchbegriff ein"
//
//
//        if #available(iOS 11.0, *) {
//            self.navigationItem.searchController = searchController
//            self.navigationItem.hidesSearchBarWhenScrolling = false
//        } else {
//            // Fallback on earlier versions
//        }
//
//        definesPresentationContext = true
//
//        // getting the dict, reading from memory
//
//        BillDataDictionary = input.inputToDict(filename: "history.csv")
//        print("")
//        print(BillDataDictionary ?? "nothing")
//        prepareData()
//    }
//
//    func prepareData() {
//        if let dict = BillDataDictionary {
//            searchobject = SearchObject(dict: dict)
//            daten = searchobject!.getDates()!
//        }
//    }
//
//
//
//
//
//    // functions to read from the memory
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        if isFiltering {
//            return 1
//        } else {
//            return daten.count
//        }
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if isFiltering {
//            if foundSth {
//                return (filteredSearchObject?.array.count)!
//            } else {
//                return 1
//            }
//        } else {
//            return searchobject!.getNumberOfRowsIn(section: section)
//        }
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if isFiltering {
//            if foundSth {
//                // found something
//                let cell = tableView.dequeueReusableCell(withIdentifier: "result") as! ResultTableViewCell
//
//                let sdm = filteredSearchObject?.getObject(byCellID: indexPath.row)
//
//                cell.cellID = (sdm?.1)!
//                cell.firma.text = sdm?.0.firma
//                cell.bruttobetrag.text = sdm?.0.bruttoBetrag
//                cell.datum.text = sdm?.0.datum
//
//
//                return cell
//
//
////                let sdm = filteredSearchObject?.getObject(byCellID: indexPath.row)
////
////
////                let cell = UITableViewCell()
////                cell.textLabel?.text = sdm?.0.firma
////
////                return cell
//            } else {
//                // found nothing
//                let cell = tableView.dequeueReusableCell(withIdentifier: "nothing")
//                cell?.isUserInteractionEnabled = false
//                return cell!
//
////                let cell = UITableViewCell()
////
////                cell.textLabel?.text = "Nichts gefunden"
////                return cell
//            }
//        } else {
//            // normal memory setup
//
//            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SuchenTableViewCell
//
//
//            let sdm = searchobject!.getObject(byIndexPath: indexPath)
//
//            cell.cellID = sdm.1
//            cell.firmenname.text = sdm.0.firma
//            cell.betrag.text = sdm.0.bruttoBetrag
//
//
//            return cell
//        }
//    }
//
//
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if isFiltering {
//            return "Suchergebnisse"
//        } else {
//            return daten[section]
//        }
//
//    }
//
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 60
//    }
//
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if isFiltering == false {
//
//        let cell = tableView.cellForRow(at: indexPath) as! SuchenTableViewCell
//
//        let senderObject = searchobject!.getObject(byCellID: cell.cellID!).billData
//
//            performSegue(withIdentifier: "detail", sender: senderObject)
//        } else {
//            let cell = tableView.cellForRow(at: indexPath) as! ResultTableViewCell
//
//            let senderObject = searchobject!.getObject(byCellID: cell.cellID!).billData
//
//            performSegue(withIdentifier: "detail", sender: senderObject)
//        }
//    }
//
//
//
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // sending the data to the detail VC
//
//        if segue.identifier == "detail" {
//            let destVC = segue.destination as! DetailTableViewController
//            destVC.senderObject = sender as? BillData
//        }
//    }
//
//
//
//    // MARK: - Table view data source for DUMMY DATA!!!
//
//    /*
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return sampleDatum.count
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section == 0 {
//            return 1
//        }
//        return 3
//    }
//
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.section == 0 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SuchenTableViewCell
//
//            cell?.firmenname.text = "BAUBÖCK'S im Kaiserhof"
//            cell?.betrag.text = "14,10 €"
//
//
//
//            return cell!
//
//        }
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SuchenTableViewCell
//
//        cell?.firmenname.text = samplefirmen[counter]
//        cell?.betrag.text = sampleBeträge[counter]
//
//
//        counter += 1
//
//        if counter == 9 {
//            counter = 0
//        }
//        return cell!
//    }
//
//
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return sampleDatum[section]
//    }
//
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 60
//    }
//
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        performSegue(withIdentifier: "detail", sender: nil)
//    }
//*/
//}
//
//
//
//
//
///*
//    TODO:
//        - checking for filtering in every tableView method
//        - preparing the filtered data
//        - (getting tipps if filtered data is empty or other things were found)
//*/
//extension SuchenTableViewController: UISearchResultsUpdating {
//    func updateSearchResults(for searchController: UISearchController) {
//
//        foundSth = false
//        filteredSearchObject = nil
//
//        if searchController.searchBar.text! != "" {
//            isFiltering = true
//            setFilteredData(withSearchText: searchController.searchBar.text!)
//            print(searchController.searchBar.text! + " suchtext")
//        } else {
//            isFiltering = false
//            filteredSearchObject = nil
//        }
//        tableView.reloadData()
//    }
//
//
////    not needed right now
////    func isSearchActive() -> Bool {
////        return searchController.isActive && searchController.searchBar.text != ""
////    }
////
//
//    // sets up the filteredSearchObject
//    // Handler can be found in "SearchHandler.swift"
//    func setFilteredData(withSearchText text: String) {
//        // checking conditions
//
//
//
//        if hasKeyzeichen(text: text) {
//            let keyzeichenTuple = isKeyzeichenSuche(searchText: text)
//
//            if keyzeichenTuple.0 {
//                if keyzeichenHandler(zeichen: keyzeichenTuple.2!, zahl: keyzeichenTuple.1!) {
//                    foundSth = true
//                } else {
//                    foundSth = false
//                }
//            }
//        } else if let dateTuple = isDateSearch(searchText: text) {
//            print("date")
//            print(dateTuple)
//            if dateHandler(date1: dateTuple.0, date2: dateTuple.1) {
//                foundSth = true
//            } else {
//                foundSth = false
//            }
//
//        } else if let jahresTuple = isJahresSuche(searchText: text) {
//            print("jahr")
//            print(jahresTuple)
//        } else if let monatsTuple = isMonatsSuche(searchText: text) {
//            print("monat")
//            print(monatsTuple)
//        } else {
//            print("last chance")
//            // normal text Search!
//            // or nothing was found!
//
//            if textHandler(text: text) {
//                foundSth = true
//            } else {
//                foundSth = false
//            }
//        }
//
//        tableView.reloadData()
//    }
//}
//
//
//
//
//
//
//
//
//
//// to regognize the searchtypes
//
//
//
//
//extension SuchenTableViewController {
//
//
//    // checks if any input with a date is inside
//
//    // returns 1: startDate, 2: endDate
//    // returns nil if something was wrong
//
//    /*
//        for example not correct format or startdate is bigger than enddate.
//    */
//    func isDateSearch(searchText: String) -> (String, String?)? {
//        var text = searchText
//        text = searchText.replacingOccurrences(of: " ", with: "")
//
//        let splited = text.split(separator: "-")
//
//
//        var dates = [String]()
//
//
//        for item in splited {
//            if isDate(date: String(item)) {
//                dates.append(String(item))
//            }
//        }
//
//
//        // checking for the wrong format, there can be one date or two dates.
//        if dates.count == 0 || dates.count > 2 {
//            return nil
//        }
//
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "d.M.yyyy"
//
//        if dates.count == 1 {
//            return (dateFormatter.string(from: dateFormatter.date(from: dates[0])!), nil)
//        } else {
//            // if the first date is smaller than the second
//            if getDateValue(date: dates[0]) > getDateValue(date: dates[1]) {
//                return nil
//            }
//
//            return (dateFormatter.string(from: dateFormatter.date(from: dates[0])!), dateFormatter.string(from: dateFormatter.date(from: dates[1])!))
//        }
//
//    }
//
//
//
//
//
//
//
//
//
//
//
//    // checks if user is looking for bills in a specific date
//    func isMonatsSuche(searchText: String) -> String? {
//
//        let text = searchText.replacingOccurrences(of: " ", with: "")
//
//        if let monate = Monate(searchText: text).getMonth() {
//            return String(monate)
//        } else {
//            return nil
//        }
//    }
//
//
//    // checks if user searches for years
//    func isJahresSuche(searchText: String) -> (String, String?)? {
//        let text = searchText.replacingOccurrences(of: " ", with: "")
//
//        let splited = text.split(separator: "-")
//
//        if splited.count == 0 || splited.count > 2 {
//            return nil
//        }
//
//        if let year1 = Int(splited[0]) {
//            if splited.count == 2 {
//                if let year2 = Int(splited[1]) {
//                    // returns the two years in the intervall
//                    if year1 - year2 < 0 {
//                        return (String(year1), String(year2))
//                    }
//                }
//            } else {
//                // return only one date
//                return (String(year1), nil)
//            }
//        }
//
//        // also returns nil if a years if not correct
//        // something did not work
//        return nil
//    }
//
//
//
//    // checks if user searches with shortcuts
//
//    // returns a bool and if found the keysymbol which is used to search
//    func isKeyzeichenSuche(searchText: String) -> (Bool, String?, String?) {
//        let charArray = Array(searchText.replacingOccurrences(of: " ", with: ""))
//
//        let keyzeichen = [">" , "=", "<"]
//
//        if charArray.count >= 2 {
//            let firstItem = String(charArray[0])
//            var type: String?
//
//            for item in keyzeichen {
//                if firstItem == item {
//                    type = item
//                }
//            }
//
//            if let _ = type {
//                var first = false
//                var zahl = ""
//
//                for item in charArray {
//                    if first == false {
//                        first = true
//                    } else {
//                        zahl += String(item)
//                    }
//                }
//
//                if let zahl = Int(zahl) {
//                    return (true, String(zahl), String(describing: type!))
//                }
//            }
//        }
//
//
//        return (false, nil, nil)
//    }
//
//
//
//
//
//
//    // überprüft ob grundsätzlich ein Keyzeichen in dem Suchtext drinnen wäre
//    func hasKeyzeichen(text: String) -> Bool {
//        var containsSth = false
//
//        // die Keyzeichen die vorkommen können
//        let zeichen = ["<", ">", "="]
//
//        for item in zeichen {
//            if text.contains(item) {
//                containsSth = true
//            }
//        }
//
//        return containsSth
//    }
//
//
//    // returns the dataValue to compare it.
//    func getDateValue(date: String) -> Int {
//        let splitedArr = date.components(separatedBy: ".")
//
//        let tag = Int(splitedArr[0])!
//        let monat = Int(splitedArr[1])! * 31
//        let jahr = Int(splitedArr[2])! * 1000
//
//        return (tag + monat + jahr)
//    }
//
//    // returns if it is a date or not
//    func isDate(date: String) -> Bool {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dd.MM.yyyy"
//
//
//        if let _ = dateFormatter.date(from: date){
//            return true
//        }
//
//        return false
//    }
//}
class tempSaveForTheNextExtention {
    static var searchBar: UISearchBar = UISearchBar.init();
    static var toolBar: UIToolbar = UIToolbar.init();
    
}

extension UITableViewController: UISearchBarDelegate{
    
    
    
    
    func addToolbar(textField: UISearchBar){
        tempSaveForTheNextExtention.searchBar = textField;
        
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default;
        toolBar.isTranslucent = true;
        toolBar.backgroundColor = UIColor.lightGray
        toolBar.tintColor = UIColor.black;
        let space = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        let betragButton = UIBarButtonItem(title: "Nummern", style: .plain, target: self, action: #selector(UITableViewController.setToBetragSearch))
        let datumButton = UIBarButtonItem(title: "Text", style: .plain, target: self, action: #selector(UITableViewController.setToDatumsbereichSearch))
        let GewährleistungButton = UIBarButtonItem(title: "Gewährleistung", style: .plain, target: self, action: #selector(UITableViewController.setToGewährleistungsSearch))
        ///
        //Setting the Shortcut buttons! (Start)//
        ///
        let biggerButton = UIBarButtonItem(title: ">", style: .plain, target: self, action: #selector(UITableViewController.addABiggerSearch))
        
        let smallerButton = UIBarButtonItem(title: "<", style: .plain, target: self, action: #selector(UITableViewController.addASmallerSearch))
        
        let equalButton = UIBarButtonItem(title: "=", style: .plain, target: self, action: #selector(UITableViewController.addAEqualSearch))
        
        let minusButton = UIBarButtonItem(title: "-", style: .plain, target: self, action: #selector(UITableViewController.addAMinusSearch))
        ///
        //Setting the Shortcut buttons! (End)//
        ///
        
        toolBar.setItems([ betragButton, space, biggerButton, space, smallerButton, space, equalButton, space, minusButton], animated: false);
        
        
        
        toolBar.sizeToFit()
        
        textField.delegate = self
        textField.inputAccessoryView = toolBar
        
        tempSaveForTheNextExtention.toolBar = toolBar;
    }
    
    
    
    @objc func setToBetragSearch(){
        let tool = tempSaveForTheNextExtention.searchBar;
        if(tool.keyboardType.rawValue == UIKeyboardType.decimalPad.rawValue){
            tool.keyboardType = UIKeyboardType.alphabet;
            tempSaveForTheNextExtention.toolBar.items?.first?.title = "Nummern"
        }
        else{
        tool.keyboardType = UIKeyboardType.decimalPad
        
            tempSaveForTheNextExtention.toolBar.items?.first?.title = "Normal"
        }
        
        tool.resignFirstResponder();
        tool.becomeFirstResponder();
        
        
        //TODO
    }
    
    
    
    @objc func setToGewährleistungsSearch(){
        //TODO
    }
    @objc func setToDatumsbereichSearch(){
        
    }
    
    @objc func addABiggerSearch(){
        let tool = tempSaveForTheNextExtention.searchBar;
        var text = tool.text;
        text?.append(">")
        tool.text = text;
        
    }
    @objc func addASmallerSearch(){
        let tool = tempSaveForTheNextExtention.searchBar;
        var text = tool.text;
        text?.append("<")
        tool.text = text;
        
    }
    @objc func addAEqualSearch(){
        let tool = tempSaveForTheNextExtention.searchBar;
        var text = tool.text;
        text?.append("=")
        tool.text = text;
        
    }
    @objc func addAMinusSearch(){
        let tool = tempSaveForTheNextExtention.searchBar;
        var text = tool.text;
        text?.append("-")
        tool.text = text;
        
    }
    
    
}

class SuchenTableViewController: UITableViewController {
    
    var dataMaster: DataMaster?
    var dates: [String]?
    
    var isSearchActive = false
    
    let searchController = UISearchController(searchResultsController: nil)
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
        
        addToolbar(textField: searchController.searchBar)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationItem.searchController?.isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        // setup the searchController
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Gib den Suchbegriff ein"
        
        
        
        if #available(iOS 11.0, *) {
            self.navigationItem.searchController = searchController
            self.navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            // Fallback on earlier versions
        }
        
        definesPresentationContext = true
        
        
        self.title = "Suchen"
        
        
        setDefaultSearchBar()
    
        
        // this should make it faster...
        DispatchQueue.global().async {
            self.prepareData()
        
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    
    }
    
    private func prepareData() {
        let start = Date().millisecondsSince1970
        if let data = Memory().read() {
            print("###### Time to read Data: \(Date().millisecondsSince1970 - start)")
            dataMaster = DataMaster.init(billdata: data)
            print("###### Time to setup Datamaster: \(Date().millisecondsSince1970 - start)")
            dates = dataMaster?.dates
        } else {
            dataMaster = DataMaster.init()
        }
        
        print("###### TOTAL: \(Date().millisecondsSince1970 - start)")
    }
    
    // Data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return 1
        } else {
            dataMaster?.searchedbilldata = nil
            return (dates?.count) ?? 0
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return dataMaster?.searchedbilldata?.count ?? 0
            
        } else {
            // default search
            return dataMaster?.getNumberOfRowsInSections(section: section) ?? 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if searchController.isActive && searchController.searchBar.text != "" {
            return ""
        } else {
            return dataMaster?.dates[section]
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if searchController.isActive && searchController.searchBar.text != "" {
            let data = dataMaster?.searchedbilldata![indexPath.row]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SuchenTableViewCell
            cell.firmenname.text = data?.rechnungsersteller
            cell.betrag.text = CFormat.correctGeldbetrag(zahl: String(data!.gesamtBrutto))
            
            return cell
        } else {
            let data = dataMaster?.getCellData(forIndexPath: indexPath)
            
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SuchenTableViewCell
            cell.firmenname.text = data?.0
            cell.betrag.text = data?.1
            
            return cell
        }
    }
    func setDefaultSearchBar(){
        searchController.searchBar.tintColor = .white

        if #available(iOS 11.0, *) {
            let sc = searchController
            let scb = sc.searchBar
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
            
            
            navigationItem.searchController = sc
            navigationItem.hidesSearchBarWhenScrolling = false
        }
        
    }
}


extension SuchenTableViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        dataMaster?.search(text: searchController.searchBar.text!)
        tableView.reloadData()
    }
    
}
