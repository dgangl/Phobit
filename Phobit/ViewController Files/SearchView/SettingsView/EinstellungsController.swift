//
//  EinstellungsController.swift
//  Phobit
//
//  Created by Julian Kronlachner on 06.01.18.
//  Copyright © 2018 Lonos. All rights reserved.
//

import UIKit
import MessageUI

class EinstellungsController: UITableViewController{
    
    //MARK- Outlets
    
    //Switch
    @IBOutlet weak var checkState: UISwitch!
    //Clear Button
    @IBOutlet weak var clearCSVtext: UIButton!
    //Views
  
    let darkView = UIView()
    
    
    //User Defaults
    let userDefaults = UserDefaults.standard
    
    @IBOutlet weak var activeFirmLable: UILabel!
    
    //Close Button
  
   
    
    //Data Source
    let data = [0, 10, 50, 100, 500, 1000, 10000]
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //MARK- SetUp Picker
       
        
        self.checkState.addTarget(self, action: #selector(action(sender:)), for: .valueChanged)
        //Preparing the Views
        
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
    }
    
    
    
    
    
}
//Table View
extension EinstellungsController{
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        let section = indexPath.section
        if(section == 1 && row == 0){
            sendEmail()
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
            mail.navigationBar.tintColor = UIColor.white
            
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



