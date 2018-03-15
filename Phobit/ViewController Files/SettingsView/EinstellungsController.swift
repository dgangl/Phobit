//
//  EinstellungsController.swift
//  Phobit
//
//  Created by Julian Kronlachner on 06.01.18.
//  Copyright © 2018 Lonos. All rights reserved.
//

import UIKit
import MessageUI

class EinstellungsController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    //MARK- Outlets
    
    //Switch
    @IBOutlet weak var checkState: UISwitch!
    //Clear Button
    @IBOutlet weak var clearCSVtext: UIButton!
    //Views
    @IBOutlet var rechnungslimitView: UIView!
    @IBOutlet var LoginView: UIView!
    let darkView = UIView()
    
    //Picker
    @IBOutlet weak var limitPicker: UIPickerView!
    //Limit Label
    @IBOutlet weak var limitLabel: UILabel!
    //User Defaults
    let userDefaults = UserDefaults.standard
    
    @IBOutlet weak var activeFirmLable: UILabel!
    
    //Close Button
    @IBAction func callCancelBTN(_ sender: Any) {
        removeViews()
    }
    @objc func removeViews(){
        rechnungslimitView.removeFromSuperview()
        LoginView.removeFromSuperview()
        darkView.removeFromSuperview()
    }
    
    
    //Data Source
    let data = [0, 10, 50, 100, 500, 1000, 10000]
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //MARK- SetUp Picker
        limitPicker.dataSource = self
        limitPicker.delegate = self
        self.checkState.addTarget(self, action: #selector(action(sender:)), for: .valueChanged)
        //Preparing the Views
        rechnungslimitView.center = self.view.center
        LoginView.center = self.view.center
        
        // Prepeare Active Firm Lable
        initializeActiveFirmLable();
       
        
        
    }
    
    func initializeActiveFirmLable() {
        // Prepeare Active Firm Lable
        //ENCODING ARRAY START//
        
        var thisArray: [UserData] = [];
        if var data = UserDefaults.standard.data(forKey: "UserData"),
            var test = NSKeyedUnarchiver.unarchiveObject(with: data) as? [UserData] {
            thisArray = test;
        } else {
            print("There is an issue with reading the User Defaults / USER STRUCTURE")
        }
        //ENCODING ARRAY END//
        if(thisArray.count < 1){
            activeFirmLable.text = "-";
        }
        else{
            activeFirmLable.text = thisArray[0].name;
        }
    }
    
    
    //AlertView and Button
    @IBAction func clearMemory(_ sender: Any) {
        // Alert Erstellen
        let alert = UIAlertController(title: "Achtung!", message: "Es werden alle Rechnungen von deinem aktuellen Account (\(UserData.getChoosen().name)) auf diesem Gerät gelöscht", preferredStyle: UIAlertControllerStyle.alert)
        
        //Buttons
        alert.addAction(UIAlertAction(title: "Löschen", style: UIAlertActionStyle.destructive, handler: {
            //Button Action
            action in
            //Create new File
            let file = Memory()
            //Overwrite everything with nothing
            file.delete(lockKey: "heUssdUWnD2331SjsadwSKS")
        }))
        alert.addAction(UIAlertAction(title: "Zurück", style: UIAlertActionStyle.cancel, handler: nil))
        
        // show alert
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    
    
    // Save state
    @objc func action(sender: UISwitch) {
        
        
        
        userDefaults.set(sender.isOn, forKey:"slider")
        
    }
    
    // Retrieve state
    override func viewWillAppear(_ animated: Bool) {
        initializeActiveFirmLable();
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        }
        setUpUserDefaults()
        setUpDarkView()
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(EinstellungsController.removeViews))
        darkView.addGestureRecognizer(tapRecognizer)
        
    }
    func getSliderState() -> Bool{
        return UserDefaults.standard.bool(forKey: "slider")
    }
    func setUpDarkView(){
        darkView.frame = (self.navigationController?.view.frame)!
        darkView.backgroundColor = UIColor.black
        darkView.alpha = 0.2
        
        
        
    }
    
    func setUpUserDefaults(){
        let UD_Slider_On = UserDefaults.standard.bool(forKey: "slider")
        self.checkState.setOn(UD_Slider_On, animated: false)
        let UD_Label_Limit = UserDefaults.standard.integer(forKey: "limit")
        if(UD_Label_Limit == 0){
            self.limitLabel.text = "Kein Limit"
        }
        else{
            self.limitLabel.text = "\(UD_Label_Limit) Rechnungen"
        }
        
        
    }
    
    
    
    
    
}
//Table View
extension EinstellungsController{
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        let section = indexPath.section
        if(section == 1 && row == 0){
            sendEmail()

        }else if(section == 2 && row == 0){
            
        }else if(section == 4 && row == 0){
            self.navigationController?.view.addSubview(darkView)
            self.navigationController?.view.addSubview(rechnungslimitView)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
}

//Sending an Email
extension EinstellungsController: MFMailComposeViewControllerDelegate{
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["phobit-support@rzlsoftware.at"])
            mail.setSubject("Feedback")
            mail.setMessageBody("<h1> Feedback </h1> <p>Feedback/ Verbesserungsvorschläge: </p>", isHTML: true)
            present(mail, animated: true)
        } else {
            let alert = UIAlertController(title: "Hoppala", message: "Bitte überprüfe deine Einstellungen damit wir eine E-Mail erstellen können", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: { action in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}

//Picker View
extension EinstellungsController{
    
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return data.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow rowInt: Int, forComponent component: Int) -> String? {
        let row = String.init(data[rowInt])
        let string = row + " Rechnungen"
        if(rowInt == 0){
            return "Kein Limit"
        }else{
            return string
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let rowString = String.init(data[row])
        
        let string = rowString + " Rechnungen"
        if(row == 0){
            limitLabel.text = "Kein Limit"
        }else{
            limitLabel.text = string
        }
        limitLabel.resignFirstResponder()
        userDefaults.set(rowString , forKey: "limit")
    }
    
    
    
}

