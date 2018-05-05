//
//  OnboardingController.swift
//  OnboardingScreen
//
//  Created by Paul Krenn on 12.01.18.
//  Copyright © 2018 Paul Krenn. All rights reserved.
//

import UIKit

class OnbordingController: UIViewController, UIGestureRecognizerDelegate {
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
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
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
            Skip.setTitle("Abbrechen", for: .normal)
            
            
        }
        else{
            loginLabel.isHidden = false;
            UserDefaults.standard.set(false, forKey: "launching");
        }
        
        let removeKeyboardListener = UITapGestureRecognizer.init(target: self, action: #selector(removeKeyboard))
        self.view.addGestureRecognizer(removeKeyboardListener)
        
    }
    
    @objc func removeKeyboard(){
        self.EmailBenutzer.resignFirstResponder();
        self.CodeBenutzer.resignFirstResponder();
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer? = nil) {
        goOn()
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
        }else{
            
            if(isAlpha() != true){
                AchtungLabel.isHidden = false
                goOn()
                return;
            }
            
            let thisUser = UserData.init(name: EmailBenutzer.text!,email: EmailBenutzer.text!, passwort: CodeBenutzer.text!, loginDate: Date.init(), uniqueString: UUID.init().uuidString);
            
                UserData.addAccount(newUser: thisUser);
            performSegue(withIdentifier: "toName", sender: self);
        }
        
        
    }
    @IBAction func skipTouched(_ sender: Any) {
        ///THE FOLLOWING IS UNCOMMENTED BECAUSE OF ALPHA///
        
//        let alert = UIAlertController(title: "Testversion", message: "Falls du dich nicht einloggen kannst, kannst du Phobit nur ausprobieren! Logge dich ein, um das volle Potenzial von Phobit auszuschöpfen!", preferredStyle: .alert)
//        let okayAction = UIAlertAction(title: "Trotzdem Testen", style: .cancel, handler: { action in   self.performSegue(withIdentifier: "toStart", sender: nil)})
//        let cancelAction = UIAlertAction(title: "Anmelden", style: .default, handler: { action in alert.dismiss(animated: true, completion: nil)})
//
//        alert.addAction(okayAction)
//        alert.addAction(cancelAction)
//
//        present(alert, animated: true, completion: nil)
        
        
        let alert = UIAlertController(title: "Alpha Version", message: "Leider musst du uns bestätigen, das du zu den Alpha Testern gehörst. Logge dich deshalb bitte ein!", preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Trotzdem Testen", style: .cancel, handler: { action in   self.performSegue(withIdentifier: "toStart", sender: nil)
            UserDefaults.standard.set(true, forKey: "InfoView")
        })

        let cancelAction = UIAlertAction(title: "Okay", style: .default, handler: { action in alert.dismiss(animated: true, completion: nil)})
        //REMOVE LATER!!!
//        alert.addAction(okayAction)
        //END REMOVE
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    @objc func goOn() {
        self.EmailBenutzer.resignFirstResponder()
        self.CodeBenutzer.resignFirstResponder()
    }
    
    func isAlpha() -> Bool {
        let db = Database.init();
        return db.checkUser(name: EmailBenutzer.text!, passwort: CodeBenutzer.text!);
    }
    
}




extension OnbordingController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print(string)
        return true
    }
}

