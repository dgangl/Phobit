//
//  SuchenTableViewController.swift
//  Phobit
//
//  Created by 73 on 09.12.17.
//  Copyright © 2017 73. All rights reserved.
//

import UIKit


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
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: NSNotification.Name(rawValue: "load"), object: nil)
    }
    
    @objc private func reloadData(){
        DispatchQueue.main.async {
            print("RELOADING DATA")
            self.tableView.reloadData()
            
        }
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



class SuchenTableViewController: UITableViewController{
    var dataMaster: DataMaster?
    var dates: [String]?
    
    
    var blackView : UIView?
    
    @IBOutlet var infoView: UIView!
    
    var isSearchActive = false
    
    let searchController = UISearchController(searchResultsController: nil)
    
    
    override func viewWillDisappear(_ animated: Bool) {
        print("TABLEVIEW DISSAPERAD")
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
        
        addToolbar(textField: searchController.searchBar)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.prefersLargeTitles = true
        //        let backButton = UIBarButtonItem.init(title: "Zurück", style: .plain, target: self, action: nil)
        //        self.navigationController?.navigationItem.setRightBarButton(backButton, animated: false)
        //        self.navigationItem.setRightBarButton(backButton, animated: false)
        self.navigationItem.title = "Suchen"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Snap View controller
        NotificationCenter.default.addObserver(self, selector: #selector(appears), name: NSNotification.Name(rawValue: AppearDisappearManager.getAppearString(id: 0)), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(disappears), name: NSNotification.Name(rawValue: AppearDisappearManager.getDisappearString(id: 0)), object: nil)
        
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: NSNotification.Name(rawValue: "loadTableView"), object: nil)
        
        // setup the searchController
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Gib den Suchbegriff ein"
        
        addTheInfoView()
        
        if #available(iOS 11.0, *) {
            self.navigationItem.searchController = searchController
            self.navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            // Fallback on earlier versions
        }
        
        definesPresentationContext = true
        
        
        self.title = "Suchen"
        self.navigationItem.rightBarButtonItems =  [UIBarButtonItem.init(barButtonSystemItem: .camera, target: self, action: #selector(pageBack)), UIBarButtonItem.init(title: "Zurück", style: .plain, target: self, action: #selector(pageBack))]
        
        
        setDefaultSearchBar()
        
        // this should make it faster...
        DispatchQueue.main.async {
            
            
            self.prepareData()
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    @objc func appears() {
        self.prepareData()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @objc func disappears() {
        
    }
    
    
    @objc func pageBack(){
        AppDelegate.snapContainer.scrollToPage(1)
        
        
    }
    
    @objc func reloadTableView(){
        self.prepareData()
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        
    }
    
    
    func addTheInfoView(){
        
        
        
        
        let infoViewBool = UserDefaults.standard.bool(forKey: "infoViewSearch")
        if infoViewBool{
            
        }else if infoViewBool == false{
            blackView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: (self.navigationController?.view.frame.width)!, height: (self.navigationController?.view.frame.height)!))
            blackView?.backgroundColor = .black
            blackView?.alpha = 0.0
            
            self.navigationController?.view.addSubview(blackView!)
            UIView.animate(withDuration: 0.7){
                self.blackView?.alpha = 0.7
            }
            
            
            infoView.center = (self.navigationController?.view.center)!
            infoView.alpha = 0.0
            self.navigationController?.view.addSubview(infoView)
            UIView.animate(withDuration: 0.7) {
                self.infoView.alpha = 0.85
                self.infoView.center = CGPoint.init(x: self.view.center.x, y: self.view.center.y - 10)
            }
            
        }
        
        
        
        
    }
    func removeInfoViewAnimation() -> Void{
        UIView.animate(withDuration: 0.8, animations: {
            self.blackView?.alpha = 0.0
        }){(result) in
            self.blackView?.removeFromSuperview()
        }
        
        
        UIView.animate(withDuration: 0.8, animations:
            {   self.infoView.center = CGPoint.init(x: self.view.center.x, y: self.view.center.y + 10)
                self.infoView.alpha = 0.0})
        {(result) in
            self.infoView.removeFromSuperview()
        }
        
    }
    
    @IBAction func nichtMehrAnzeigen(_ sender: Any) {
        removeInfoViewAnimation()
        UserDefaults.standard.set(true, forKey: "infoViewSearch")
    }
    
    @IBAction func okayAction(_ sender: Any) {
        removeInfoViewAnimation()
    }
    
    
    public func prepareData() {
        let start = Date().millisecondsSince1970
        if let data = Memory().read() {
            print("###### Time to read Data: \(Date().millisecondsSince1970 - start)")
            dataMaster = DataMaster.init(billdata: data)
            print("###### Time to setup Datamaster: \(Date().millisecondsSince1970 - start)")
            dates = dataMaster?.dates
        } else {
            dataMaster = DataMaster.init()
            dates = nil
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
    //    var anzahl = 10;
    //    var count = 0;
    //    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    //
    //        if indexPath.row == anzahl{
    //            for _ in 0...9{
    //                if((dataMaster?.dates.count)!-1 <= count){
    //                dataMaster?.dates[count]
    //                    count += 1;
    //                }
    //                anzahl += 10;
    //            }
    //        }
    //        self.reloadInputViews()
    //
    //    }
    
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
        //        searchController.searchBar.tintColor = .white
        
        if #available(iOS 11.0, *) {
            let sc = searchController
            let scb = sc.searchBar
            //            scb.tintColor = UIColor.white
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
