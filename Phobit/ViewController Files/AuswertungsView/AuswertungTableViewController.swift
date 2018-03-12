//
//  AuswertungTableViewController.swift
//  Phobit
//
//  Created by LonoS on 09.12.17.
//  Copyright © 2017 LonoS. All rights reserved.
//

import UIKit

class AuswertungsTableViewController: UITableViewController {
    
    let sections = ["Rechnungsersteller", " ", "Steueraufstellung", "Kontierungsvorschlag", "Bezahlung"]
    var bill: BillData2?
    var tableDict: [IndexPath:Any]?
    var image : UIImage?
    
    
    @IBOutlet weak var imagePicker: UIImageView!
    @IBOutlet weak var noImgeFoundLBL: UILabel!
    
    // falls der VC als DetailView benutzt wird. (defaultmäßig false)
    var isDetail = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
        } else {
            
            getImage()
            // navBar für detail vorbereiten
            self.title = bill?.rechnungsersteller
//            self.navigationController?.navigationBar.backItem?.backBarButtonItem?.title = "Zurück"
            self.navigationController?.navigationBar.backItem?.title = "Zurück"
        }
    }
    
    @objc func returnHome() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func returnHomeAndSave() {
        bill?.merchChanges(tableDict: tableDict!)
        print("saving BillData")
        let mem = Memory.init()
        setImage()
        mem.save(input: bill!, append: true, target: self)
        //
    }
    
    
    
    
    
    
    // DATA SOURCE
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            return (bill?.getNumberOfSteuerzeilen())! + 2
        }
        
        return 1
    }
    
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 2 {
            // steuerzeile
            // userInteraction is disabled in main.storyboard
            if indexPath.row == 0 {
                // erste Zeile Überschriften
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "spaltenÜberschriften")
                return cell!
            } else if indexPath.row == (bill?.getNumberOfSteuerzeilen())!+1 {
                
                // gesamtBrutto Zelle
                let cell = tableView.dequeueReusableCell(withIdentifier: "gesamtBrutto") as! GesamtBruttoTableViewCell
                cell.textfield.text = "Gesamt-Brutto        \(CFormat.correctGeldbetrag(zahl: String(describing: (bill?.gesamtBrutto)!)))"
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
        } else {
            // item
            let object = tableDict![indexPath] as! Item
            
            if let descr = object.description {
                let cell = tableView.dequeueReusableCell(withIdentifier: "twoItem") as! TwoItemsCell
                cell.leftItem.text = object.value
                cell.rightItem.text = descr
                
                if(isDetail) {cell.accessoryType = .none; cell.isUserInteractionEnabled = false}
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "oneItem") as! TextCell
                cell.textField.text = object.value
                
                if(isDetail) {cell.accessoryType = .none; cell.isUserInteractionEnabled = false}
                
                return cell
            }
        }
    }
    
    func setImage(){
        //ImageSaving Class
        let i = ImageData()
        let iU = ImageUpload()
        //let url = "https://services.rzlsoftware.at/rzlocrservice/DoOCR"
        let url = "https://services.rzlsoftware.at/rzlocrservice"
        //Setting a new UUID for each image so we dont have anything twice.
        let uuid = UUID.init()
        //Writing image to the document directory
        let string = uuid.uuidString
        bill?.imageURL = string
        i.writeImageTo(name: string, imageToWrite: image!)
        print("UUID FROM SETTING THE IMAGE \(uuid)")
        iU.uploadImg(img: image!, fullUrl: url)
    }
    
    func getImage(){
        let i = ImageData()
        
        if bill?.imageURL == "" {print("no image url found"); return}
        
        
        
        if let image = i.getImage(name: (bill?.imageURL)!) {
            
            imagePicker.image = image
        }
    
    }
    
    
    
    
}

