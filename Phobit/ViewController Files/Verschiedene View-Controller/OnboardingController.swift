//
//  OnboardingController.swift
//  OnboardingScreen
//
//  Created by Paul Krenn on 12.01.18.
//  Copyright © 2018 Paul Krenn. All rights reserved.
//

import UIKit
import MessageUI

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
            
            isAlpha();
            
            
        }
        
        
    }
    @IBAction func skipTouched(_ sender: Any) {
        ///THE FOLLOWING IS UNCOMMENTED BECAUSE OF ALPHA///
        
//        let alert = UIAlertController(title: "Testversion", message: "Falls du dich nicht einloggen kannst, kannst du Phobit nur ausprobieren! Logge dich ein, um das volle Potenzial von Phobit auszuschöpfen!", preferredStyle: .alert)
//
//
//
//
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
        if(Skip.currentTitle! == ""){
            self.performSegue(withIdentifier: "toStart", sender: self)
        }else{
            present(alert, animated: true, completion: nil)
        }
        
    }
    @objc func goOn() {
        self.EmailBenutzer.resignFirstResponder()
        self.CodeBenutzer.resignFirstResponder()
    }
    
    func isAlpha() {
        
        let alert = UIAlertController(title: nil, message: "Überprüfe Eingabe...", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        
        
        //SET ALERT VIEW HERE
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
 
        
        
        let db = Database.init();
        var okay: Bool = false;
        
        
        
        
        //return db.checkUser(name: EmailBenutzer.text!, passwort: CodeBenutzer.text!);
        
        db.checkUser(name: EmailBenutzer.text!, passwort: CodeBenutzer.text!) { (goAhead) in
            
            okay = goAhead;
            
            if(goAhead){
                let thisUser = UserData.init(name: self.EmailBenutzer.text!,email: self.EmailBenutzer.text!, passwort: self.CodeBenutzer.text!, loginDate: Date.init(), uniqueString: UUID.init().uuidString);
                
                UserData.addAccount(newUser: thisUser);
                    //Clear Alert View here
                alert.dismiss(animated: true, completion: {
                    self.performSegue(withIdentifier: "toName", sender: self);
                })

            }
            else{
                
                self.AchtungLabel.isHidden = false
                //Clear Alert View here
                alert.dismiss(animated: true, completion: {
                    self.goOn();
                })
            }
        }
        
        //Clear Alert View here
       
    }
    @IBAction func noCode(_ sender: Any) {
        sendEmail()
        
    }
    
}






extension OnbordingController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print(string)
        return true
    }
}


extension OnbordingController: MFMailComposeViewControllerDelegate{
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.navigationBar.tintColor = UIColor.white
            
            mail.setToRecipients(["feedback.AlphaUser@gmail.com"])
            mail.setSubject("Ich habe noch keinen Alpha-Zugang")
            mail.setMessageBody("<h1> Alpha-Code </h1> <p> Ich habe noch keinen Alpha-Code, bitte sendet mir einen. </p>", isHTML: true)
            present(mail, animated: true)
        } else {
            let alert = UIAlertController(title: "Hoppala", message: "Bitte überprüfe deine Einstellungen damit wir eine E-Mail erstellen können.", preferredStyle: UIAlertControllerStyle.alert)
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


