//
//  AuswertungTableViewController.swift
//  Phobit
//
//  Created by LonoS on 09.12.17.
//  Copyright © 2017 LonoS. All rights reserved.
//

import UIKit
import FirebaseAnalytics

class AuswertungsTableViewController: UITableViewController{
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    let sections = ["Rechnungsersteller", "Datum", "Steueraufstellung", "Verwendungszweck", "Bezahlung"]
    var bill: BillData2?
    var tableDict: [IndexPath:Any]?
    var image : UIImage?
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    @IBOutlet weak var imagePicker: UIImageView!
    @IBOutlet weak var noImgeFoundLBL: UILabel!
    
    
    
    // falls der VC als DetailView benutzt wird. (defaultmäßig false)
    var isDetail = false
    var noBillData = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(noBillData){
            self.bill = BillData2.init(datum: "Datum eingeben", rechnungsersteller: "Bitte Rechnungsersteller eingeben", kontierung: "Verwendungszweck auswählen", bezahlung: "Bezahlungsart auswählen")
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(addSteuerzeile), name: NSNotification.Name(rawValue: "addSteuerzeile"), object: nil)
        
        
        if(bill?.rechnungsersteller != "Bitte Rechnungsersteller eigeben"){
            self.navigationItem.title = bill?.rechnungsersteller
        }
    
        //zooming for image
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 6.0
        
        let screenSize: CGRect = UIScreen.main.bounds
        imageView.image?.accessibilityFrame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
        imageView.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
        
        
        if let bill = bill {
            tableDict = bill.getTableDict()
        }
        
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        }
        
        
        // bei auswertung muss andere search bar gezeigt werden.
        if(isDetail == false){
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Senden", style: .done, target: self, action: #selector(returnHomeAndSave))
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Zurück", style: .plain, target: self, action: #selector(returnHome))
            imagePicker.image = image
            noImgeFoundLBL.isHidden = true
        } else if(!UserData.getChoosen().name.elementsEqual("Demo Benutzer")){
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Speichern", style: .done, target: self, action: #selector(speichern))
            
            getImage()
            // navBar für detail vorbereiten
            self.title = bill?.rechnungsersteller
            self.navigationController?.navigationBar.backItem?.title = "Zurück"
        }else if(UserData.getChoosen().name.elementsEqual("Demo Benutzer")){
            tableView.allowsSelection = false
            tableView.isUserInteractionEnabled = false
            
        }
        if(!isDetail){
            self.navigationItem.title = "Auswertung"

        }
    }
    
    
    
    
    override func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imagePicker
    }
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView?{
        return self.imagePicker
    }
    @objc func addSteuerzeile(){
        self.bill?.steuerzeilen.append(Steuerzeile.init(prozent: 0, prozentbetrag: 0.0, netto: 0.0, brutto: 0.0))
        self.tableDict![IndexPath.init(row: (bill?.getNumberOfSteuerzeilen())!, section: 2)] = Steuerzeile.init(prozent: 0, prozentbetrag: 0.0, netto: 0.0, brutto: 0.0)
        print("Added steuerzeile")
        self.tableView.reloadData()
        
        
        
        
    }
    @objc func returnHome() {
        Analytics.logEvent("Rechnung_gescanned_und_abgebrochen", parameters: [:])
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc public func speichern(){
        bill?.merchChanges(tableDict: tableDict!)
        print("saving BillData")
        
        if(bill?.rechnungsersteller.elementsEqual("Bitte Rechnungsersteller eingeben."))!{
            let alert = UIAlertController.init(title: "Hoppala", message: "Leider können wir die Rechnung nicht speichern wenn du den Rechnungsersteller nicht eingegeben hast.", preferredStyle: .alert)
            let okayAction = UIAlertAction.init(title: "Okay", style: .cancel, handler: {action in alert.dismiss(animated: true, completion: nil)})
            alert.addAction(okayAction)
            present(alert, animated: true, completion: nil)
        }else{
            
            let mem = Memory.init()
            guard let allBills = mem.read() else { print("Bills is empty."); return}
            var newArray : [BillData2] = []
            for bill in allBills{
                
                print(bill.uuid)
                print(self.bill?.uuid)
                
                if(bill.uuid == self.bill?.uuid && bill.imageURL == self.bill?.imageURL){
                    print("SAVED NEW BILL DATA")
                    print("\(bill.rechnungsersteller) was the right one")
                    newArray.append(self.bill!)
                    
                }else{
                    newArray.append(bill)
                }
            }
            print("THE NEW ARRAY HAS \(newArray.count) BILL DATAS IN IT. \n THE OLD HAD \(allBills.count)")
            mem.saveArray(inputArray: mem.sortBillData(array_to_sort: newArray))
            
            
            
            
                self.navigationItem.title = self.bill?.rechnungsersteller
            
            //sends a notification to the tableView to reload its data after it got changed.
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)

            
            
            //NEEDED FOR DATABASE SAVING
            //OVERWRITE EXISTING BILL.
            
            
        }
        
    }
    
    private func showAlert(title : String, message: String, type : UIAlertControllerStyle){
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: type)
        let okayAction = UIAlertAction.init(title: "Okay", style: .cancel, handler: {action in alert.dismiss(animated: true, completion: nil)})
        alert.addAction(okayAction)
        present(alert, animated: true, completion: nil)
        
    }
    var goOn = false;
    @objc func returnHomeAndSave() {
        let mem = Memory.init()
        if(!noBillData){
        if((mem.duplicateProver(input: bill!) && !goOn)){
            
            let alert = UIAlertController.init(title: "Vorsicht.", message: "Du hast diese Rechnung bereits eingescanned. Bist du dir sicher das du sie ein zweites Mal speichern willst?", preferredStyle: .alert)
            let neinAction = UIAlertAction.init(title: "Diese Rechnung verwerfen", style: .destructive, handler: {action in self.returnHome(); alert.dismiss(animated: true, completion: nil)})
            let vlltAction = UIAlertAction.init(title: "Diese Rechnung trotzdem speichern.", style: .default, handler: {action in
                self.goOn = true; self.returnHomeAndSave(); alert.dismiss(animated: true, completion: nil)
            })
            
            alert.addAction(neinAction)
            alert.addAction(vlltAction)
            present(alert, animated: true, completion: nil)
            }
            
        }
        
        
        bill?.merchChanges(tableDict: tableDict!)

        
        if(bill?.rechnungsersteller.elementsEqual("Bitte Rechnungsersteller eingeben"))!{
            showAlert(title: "Vorsicht", message: "Wir können diese Rechnung nicht ohne einen Rechnungsersteller speichern", type: .alert)
        }else if bill?.getNumberOfSteuerzeilen() == 0{
            showAlert(title: "Warte", message: "Wir können diese Rechnung leider nicht speichern da diese Rechnung leer ist und noch keine Beträge hat.", type: .alert)
        }else if (bill?.kontierung.elementsEqual("Verwendungszweck auswählen"))!{
            showAlert(title: "Ups", message: "Leider kann diese Rechnung nicht gespeichert werden da du noch keinen Verwendungszweck eingegeben hast.", type: .alert)
        }else if (bill?.bezahlung.elementsEqual("Bezahlungsart auswählen"))!{
            showAlert(title: "Oh nein", message: "Du hast noch nicht angegeben wie du diese Rechnung beglichen hast. Bitte mach das bevor wir deine Rechnung speichern.", type: .alert)
        }else if (bill?.datum.elementsEqual("Datum eingeben"))!{
            showAlert(title: "Schade", message: "Du musst leider ein Datum für deinen Beleg angeben. Was für ein Chaos eine Welt ohne Datum wäre...", type: .alert)
        }else{
        
        bill?.merchChanges(tableDict: tableDict!)
        print("saving BillData")
        setImage()
        mem.save(input: bill!, append: true, target: self)
            
        //SORTING THE ARRAY RIGHT AT THE BEGINNING
           // if let array = mem.read(){mem.saveArray(inputArray: array)} else {return}
            
        
        //NEEDED FOR DATABASE SAVING
        let dataBase = Database.init();
        let companName = bill?.rechnungsersteller;
        if(companName == nil || (companName?.elementsEqual(""))!){
            return;
        }
        let OCRString = UserDefaults.standard.string(forKey: "OCRstring");
        
            Analytics.logEvent("Rechnung_gescanned_und_hochgeladen", parameters: [:])
        
        
        dataBase.addNew(wholeString: OCRString, companyName: (bill?.rechnungsersteller)!, Date: (bill?.getDate())!, Brutto: (bill?.gesamtBrutto)!, Netto: getAllNetto(), TenProzent: getProzentsatz(value: 10), ThirteenProzent: getProzentsatz(value: 13), NineteenProzent: getProzentsatz(value: 19), TwentyProzent: getProzentsatz(value: 20), Kontierung: (bill?.kontierung)!);
            
            
        }
    }
    
    func getAllNetto() -> Double {
        var all = 0.0;
        
        for item in (bill?.steuerzeilen)! {
            all = all + item.getNetto();
        }
        
        return all;
    }
    
    
    func getProzentsatz(value: Int) -> Double{
        var finalBetrag : Double = 0;
        for steuer in (bill?.steuerzeilen)!{
            if(steuer.getProzent() == value){
                finalBetrag = steuer.getProzentbetrag();
            }
        }
        
        return finalBetrag;
    }
    
    // DATA SOURCE
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            if(noBillData){
                if(bill?.steuerzeilen.isEmpty)!{
                    return 1
                }else{
                    return (bill?.getNumberOfSteuerzeilen())! + 3
                }
                
            }else if(!noBillData){
                return (bill?.getNumberOfSteuerzeilen())! + 2
            }
        }
        
        return 1
    }
    
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 2 {
            if(bill?.steuerzeilen.isEmpty)!{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "addLine") as! addSteuerzeileTableViewCell
                    return cell
            }else{
                
            
            
           
            // steuerzeile
            if indexPath.row == 0 {
                // erste Zeile Überschriften
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "spaltenÜberschriften")
                return cell!
            }   else if indexPath.row == (bill?.getNumberOfSteuerzeilen())!+2 && !noBillData{
                let cell = tableView.dequeueReusableCell(withIdentifier: "addLine") as! addSteuerzeileTableViewCell
                return cell
                
            } else if indexPath.row == (bill?.getNumberOfSteuerzeilen())!+1 {
                
                // gesamtBrutto Zelle
                let cell = tableView.dequeueReusableCell(withIdentifier: "gesamtBrutto") as! GesamtBruttoTableViewCell
                cell.textfield.text = "Gesamt-Brutto        \(CFormat.correctGeldbetrag(zahl: String(describing: (bill?.gesamtBrutto)!)))"
                return cell
            }else if indexPath.row == (bill?.getNumberOfSteuerzeilen())! + 2 && noBillData {
                let cell = tableView.dequeueReusableCell(withIdentifier: "addLine") as! addSteuerzeileTableViewCell
                return cell
                
            } else {
                let object = tableDict![indexPath] as! Steuerzeile
                let cell = tableView.dequeueReusableCell(withIdentifier: "spalten") as! SpaltenTableViewCell
                cell.prozent.text = String(object.getProzent())
                cell.netto.text = CFormat.correctGeldbetrag(zahl: String(object.getNetto()))
                cell.brutto.text = CFormat.correctGeldbetrag(zahl: String(object.getBrutto()))
                cell.mwst.text = CFormat.correctGeldbetrag(zahl: String(object.getProzentbetrag()))
                cell.row = indexPath.row-1
                cell.delegate = self
                return cell
            
                }
            }
        } else {
            // item
            let object = tableDict![indexPath] as! Item
                let cell = tableView.dequeueReusableCell(withIdentifier: "oneItem") as! TextCell
                cell.textField.text = object.value
                
//                if(isDetail) {cell.accessoryType = .none; cell.isUserInteractionEnabled = false}
                
                return cell
            
        }
    }
    
    func setImage(){
        guard let image = image else {
            print("no image to be saved")
            return;
        }
        
        //ImageSaving Class
        let i = ImageData()
        //Setting a new UUID for each image so we dont have anything twice.
        let uuid = UUID.init()
        //Writing image to the document directory
        let string = uuid.uuidString
        bill?.imageURL = string
        
        i.writeImageTo(name: string, imageToWrite: image)
        print("UUID FROM SETTING THE IMAGE \(uuid)")
    }
    
    func getImage(){
        let i = ImageData()
        
        if bill?.imageURL == "" {print("no image url found");
            return
        }
        
        
        
        if let image = i.getImage(name: (bill?.imageURL)!) {
            
            imagePicker.image = image
            self.noImgeFoundLBL.isHidden = true
        }
    
    }
    
    @IBOutlet var informationSheet: UIView!
    func customNotification() {
      
            // present the sheet
            
            informationSheet.alpha = 0
            informationSheet.center = CGPoint.init(x: self.view.center.x, y: UIScreen.main.bounds.maxY - 90)
            self.view.addSubview(informationSheet)
        
        
            // animate in
            UIView.animate(withDuration: 0.3) {
                self.informationSheet.alpha = 1
                
            }
            
            
            // animate out after 5 seconds
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) {
                
                UIView.animate(withDuration: 0.2, animations: {
                    self.informationSheet.alpha = 0
                }, completion: { (success) in
                    self.informationSheet.removeFromSuperview()
                    self.informationSheet.alpha = 1
                })
            }
        
    }
    
    
}



