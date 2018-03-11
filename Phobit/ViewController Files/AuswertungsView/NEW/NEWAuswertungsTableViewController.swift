//
//  NEWAuswertungsTableViewController.swift
//  Phobit
//
//  Created by Paul Wiesinger on 22.01.18.
//  Copyright © 2018 Paul Wiesinger. All rights reserved.
//

import UIKit

class NEWAuswertungsTableViewController: UITableViewController {
    
    private let sections = ["Rechnungsersteller", "Belegdaten", "Steuersätze", "Kontierungsvorschlag", "Bezahlung"]
    
    //Mit 0.0 initialisieren um leeres Objekt zu erzeugen. NUR VORÜBERGEHEND!//
    var bill = BillData(0.0)
    
    
    // for tableView work
    private var dataArray = [Item]()
    
    // for textField delegate, to determine if numbers are entered.
    private var numberInput = false
    
    private var darkView = UIView()
    
    // current arrayIndex for changing
    private var changedIndex: Int? = nil
    
    
    
    // Sheets
    @IBOutlet var datumsSheet: UIView!
    @IBOutlet weak var datepicker: UIDatePicker!
    
    
    @IBOutlet var eingabeSheet: UIView!
    @IBOutlet weak var eingabeSheetTF: UITextField!
    @IBOutlet weak var eingabeSheetLBL: UILabel!
    
    
    
    
    fileprivate func prepareDarkView() {
        // preparing darkview
        darkView.frame = (self.navigationController?.view.frame)!
        darkView.backgroundColor = UIColor.black
        darkView.alpha = 0.2
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(cancelSheet(_:)))
        darkView.addGestureRecognizer(tapRecognizer)
    }
    
    fileprivate func prepareSheets() {
        // preparing sheets
        eingabeSheet.center = CGPoint(x: (self.navigationController?.view.frame.midX)!, y: ((self.navigationController?.view.frame.midY)!/1.1))
        datumsSheet.center = (self.navigationController?.view.center)!
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        }
        
        // see AuswertungTFDelegate.swift for more information
        eingabeSheetTF.delegate = self
        
        
        // getting the array from the billdata
        dataArray = bill.getTableViewArray()
        
        // preparing UI
        prepareDarkView()
        prepareSheets()
        
        eingabeSheetTF.inputAccessoryView = CustomToolbar.getAuswertungsToolbar(action: #selector(setChange), target: self)
        eingabeSheetTF.autocorrectionType = .no
        
        
        // navigationbar
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Senden", style: .done, target: self, action: #selector(returnHomeAndSave))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Zurück", style: .plain, target: self, action: #selector(returnHome))
    }
    
    
    @objc func returnHome() {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func returnHomeAndSave() {
        if(bill.pruefeBillData() == false || bill.pruefeRechnerischeRichtigkeit() == false){
            let alert = UIAlertController(title: "Etwas stimmt nicht.", message: "Bitte überprüfe deine Eingabe und fülle alle Felder aus.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: { action in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }else{
        let save = File()
        
        save.saveFile(line: CSVStringBuild(), append: true, filename: "history.csv")
            //save.save(bill: bill, append: true)
        
        print("saved")
        
        self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    // Methode zum String bauen für CSV :: NOT USED
    func CSVStringBuild() -> String {


        //STRING::
        //Name, Datum, Konto, Netto, Steuer 0%, Steuer 10%, Steuer 13%, Steuer 19%, Steuer 20%, Brutto, Bezahlungsart//
        let csvString = ("\(bill.getRechnungsersteller());\(bill.getDatum());\(bill.getKontierung());\(bill.getNetto());\(bill.getSteuer0());\(bill.getSteuer10());\(bill.getSteuer13());\(bill.getSteuer19());\(bill.getSteuer20());\(bill.getBrutto());\(bill.getBezahlart());\\")
        print(csvString)
        return csvString
    }
    
    
    fileprivate func dissmissSheet() {
        eingabeSheet.removeFromSuperview()
        datumsSheet.removeFromSuperview()
        darkView.removeFromSuperview()
        
        eingabeSheetTF.text = ""
        changedIndex = nil
    }
    
    @IBAction func cancelSheet(_ sender: UIButton) {
        dissmissSheet()
    }
    
    
    
    @objc func setChange() {
        if let index = changedIndex {
            
            if let text = eingabeSheetTF.text {
                if text != "" {
                    // setting the change
                    dataArray[index].value = text
                    bill.checkChanges(onArray: dataArray)
                    dataArray = bill.getTableViewArray()
                }
            }
            tableView.reloadData()
        } else {
            print("keine Index wurde gefunden: setChange()")
        }
        
        dissmissSheet()
    }
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - Table view data source
    
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
            return bill.getAnzahlSteuersätze()
            
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
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = aufsummieren(indexPath: indexPath)
        
        if index == 0 {
            presentSheet(inputType: .text, description: "Rechnungsersteller", arrayIndex: index)
        } else {
            switch index {
            case 1:
                presentSheet(inputType: .datum, description: "Datum", arrayIndex: index)
            case (dataArray.count - 1):
                presentSheet(inputType: .bezahlung, description: "Bezahlart", arrayIndex: index)
            case (dataArray.count - 2):
                presentSheet(inputType: .kontierung, description: "Kontierung", arrayIndex: index)
            default:
                // steuern...
                let cell = tableView.cellForRow(at: indexPath) as! TwoItemsCell
                let descr = cell.rightItem.text ?? "Fehler: Beschreibung nicht gefunden!"
                presentSheet(inputType: .betrag, description: "\(descr)betrag", arrayIndex: index)
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    private func presentSheet(inputType: InputType, description: String, arrayIndex: Int) {
        // setting up darkview
        self.navigationController?.view.addSubview(darkView)
        
        
        
        switch inputType {
        case .text:
            self.navigationController?.view.addSubview(eingabeSheet)
            eingabeSheetTF.keyboardType = .asciiCapable
            eingabeSheetTF.placeholder = dataArray[arrayIndex].value
            eingabeSheetLBL.text = getLBLText(descr: description)
            
        case .betrag:
            self.navigationController?.view.addSubview(eingabeSheet)
            eingabeSheetTF.keyboardType = .decimalPad
            eingabeSheetTF.placeholder = dataArray[arrayIndex].value
            eingabeSheetLBL.text = getLBLText(descr: description)
            numberInput = true
            
        case .datum:
            self.navigationController?.view.addSubview(datumsSheet)
            let dateString = bill.getDatum()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            let dateObjc = dateFormatter.date(from: dateString)
            datepicker.date = dateObjc!
            
        case .kontierung:
            self.navigationController?.view.addSubview(eingabeSheet)
            eingabeSheetTF.keyboardType = .numberPad
            eingabeSheetTF.placeholder = dataArray[arrayIndex].value
            eingabeSheetLBL.text = "Gib bitte die Kontierung ein."
        case .bezahlung:
            // todo
            print("bezahlung \(arrayIndex)")
        default:
            print("founde no match for selection in presenSheet")
        }
        
        changedIndex = arrayIndex
    }
    
    
    
    
    // summiert auf um den index im array zu erhalten.
    private func aufsummieren(indexPath: IndexPath) -> Int {
        var numberOfRows = 0
        
        for number in 0..<indexPath.section {
            numberOfRows += tableView.numberOfRows(inSection: number)
        }
        
        numberOfRows += indexPath.row
        
        return numberOfRows
    }
    
    private func getLBLText(descr: String) -> String {
        return "Gib bitte den \(descr) ein."
    }
}

