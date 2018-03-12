//
//  OnboardingController.swift
//  OnboardingScreen
//
//  Created by Paul Krenn on 12.01.18.
//  Copyright © 2018 Paul Krenn. All rights reserved.
//

import UIKit

class OnbordingController: UIViewController {
    //TextFields//
    @IBOutlet weak var EmailBenutzer: UITextField!
    @IBOutlet weak var CodeBenutzer: UITextField!
    //Buttons//
    // @IBOutlet weak var Login: UIButton!
    @IBOutlet weak var Skip: UIButton!
    //Labels//
    @IBOutlet weak var AchtungLabel: UILabel!
    @IBOutlet weak var AlreadyUsedLabel: UILabel!
    
    @IBOutlet weak var loginLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Login.layer.cornerRadius = 20
        Skip.layer.cornerRadius = 20
        // Do any additional setup after loading the view.
        EmailBenutzer.delegate = self
        EmailBenutzer.autocorrectionType = .no
        EmailBenutzer.returnKeyType = UIReturnKeyType.continue
        
        
        
        CodeBenutzer.delegate = self
        CodeBenutzer.autocorrectionType = .no
        CodeBenutzer.returnKeyType = UIReturnKeyType.done
        
        if(UserDefaults.standard.bool(forKey: "launching") == false){
            loginLabel.isHidden = true;
            Skip.isHidden = true;
            
            
        }
        else{
            loginLabel.isHidden = false;
            UserDefaults.standard.set(false, forKey: "launching");
        }
        
    }
    
    @IBAction func goOnToTheNext(_ sender: UITextField) {
        self.EmailBenutzer.endEditing(true)
        self.EmailBenutzer.resignFirstResponder()
        self.CodeBenutzer.becomeFirstResponder()
        self.CodeBenutzer.accessibilityContainerType = UIAccessibilityContainerType.none
    }
    @IBAction func checkPasswordAndContinue(_ sender: UITextField) {
        continuetouched()
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    @objc func continuetouched() {
        if(EmailBenutzer.text == "" || CodeBenutzer.text == ""){
            AchtungLabel.isHidden = false
            goOn()
        }
        else{
            let thisUser = UserData.init(name: EmailBenutzer.text!,email: EmailBenutzer.text!, passwort: CodeBenutzer.text!, loginDate: Date.init());
            
            var nsarr: [UserData] = [];
            
            if let data = UserDefaults.standard.data(forKey: "UserData"),
                let test = NSKeyedUnarchiver.unarchiveObject(with: data) as? [UserData] {
                nsarr = test;
            } else {
                print("There is an issue")
            }
            
            
            
            var isTaken = false;
            
            for test in nsarr{
                
                if(thisUser == test){
                    AchtungLabel.isHidden = true;
                    AlreadyUsedLabel.isHidden = false;
                    isTaken = true;
                }
                
            }
            
            
            
            
            if(isTaken == false){
                
                
                
                
                nsarr.append(thisUser);
                let encodedData = NSKeyedArchiver.archivedData(withRootObject: nsarr)
                UserDefaults.standard.set(encodedData, forKey: "UserData");
                
                
                // UserDefaults.standard.setValue(nsarr, forKey: "UserData");
                performSegue(withIdentifier: "toName", sender: nil);
                
            }
            
            
            
        }
        
        
    }
    @IBAction func skipTouched(_ sender: Any) {
        let alert = UIAlertController(title: "Testversion", message: "Falls du dich nicht einloggst kannst du Phobit nur ausprobieren! Logge dich ein um das volle Potenzial von Phobit auszuschöpfen!", preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Testen", style: .cancel, handler: { action in   self.performSegue(withIdentifier: "toStart", sender: nil)})
        let cancelAction = UIAlertAction(title: "Anmelden", style: .default, handler: { action in alert.dismiss(animated: true, completion: nil)})
        
        alert.addAction(okayAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
        
        
        
    }
    @objc func goOn() {
        self.EmailBenutzer.resignFirstResponder()
        self.CodeBenutzer.resignFirstResponder()
    }
    
    
    
}


extension OnbordingController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print(string)
        return true
    }
}

