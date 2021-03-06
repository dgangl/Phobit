//
//  ViewController.swift
//  newLoginScreen
//
//  Created by 73 on 07.03.18.
//  Copyright © 2018 73. All rights reserved.
//

import UIKit

class SetANameOnboarding: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var TextField: UITextField!
    @IBOutlet weak var goOn: UIButton!
    @IBOutlet weak var FehlerMeldung: UILabel!
    override func viewDidLoad() {
        TextField.addTarget(self, action: #selector(moveUp), for: .editingDidBegin)
        TextField.addTarget(self, action: #selector(moveDown), for: .editingDidEnd)

        
        
        super.viewDidLoad()
        TextField.returnKeyType = UIReturnKeyType.done
        goOn.layer.cornerRadius = 10;
        TextField.becomeFirstResponder();
        let removeKeyboardListener = UITapGestureRecognizer.init(target: self, action: #selector(removeKeyboard))
        self.view.addGestureRecognizer(removeKeyboardListener)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func handleTap(sender: UITapGestureRecognizer? = nil) {
        self.TextField.resignFirstResponder()
    }
    
    @IBAction func goAhead(_ sender: Any) {
        ClickedButton(self)
        
    }
    
    @objc func removeKeyboard(){
        self.TextField.resignFirstResponder()
    }
    
    @IBAction func checkIt(_ sender: Any) {
        print("checkStringLength called")
        if(TextField.text == nil){
            return
        }
        var text = TextField.text!
        if(text.count >= 15){
            
            FehlerMeldung.isHidden = false;
            
            
            TextField.text = text;
        }
        else{
            FehlerMeldung.isHidden = true;
            
        }
        
        
    }
    
    
    @IBAction func test(_ sender: Any) {
        checkIt(sender)
    }
    
    @IBAction func ClickedButton(_ sender: Any) {
        var users = UserData.getWholeArray();
        let actual = users.remove(at: 0)
        if(TextField.text != nil){
            
            actual.name = TextField.text!;
            
        }
        
        
        users.insert(actual, at: 0)
        //Check later wheater the Account is already used!
        if(true){
            UserData.saveNew(newArray: users)
            let db = Database.init();
            db.setTheNameForTheUser(nameOfTheUser: TextField.text!);
            self.performSegue(withIdentifier: "toStart", sender: self);
        }
        else{
            //Presentig Alert View Start//
            let alertController = UIAlertController(title: "Vergeben", message:
                "Leider ist bereits ein Account mit dem selben Namen angemeldet", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            }
            
        
        //Presenting Alert View End//
            swipeViewSetup()
        }
    
    @objc func moveUp(){
        UIView.animate(withDuration: 0.2){
            self.view.center = CGPoint.init(x: self.view.center.x, y: self.view.center.y - 100)
        }
    }
    
    @objc func moveDown(){
        UIView.animate(withDuration: 0.2){
            self.view.center = CGPoint.init(x: self.view.center.x, y: self.view.center.y + 100)
        }
    }
    
    
    func swipeViewSetup(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let left = storyboard.instantiateViewController(withIdentifier: "left")
        let middle = storyboard.instantiateViewController(withIdentifier: "middle")
        let right = storyboard.instantiateViewController(withIdentifier: "right")
        
        
        let snapContainer = SnapContainerViewController.containerViewWith(left, middleVC: middle, rightVC: right)
        
        self.view.window?.rootViewController = snapContainer
        self.view.window?.makeKeyAndVisible()
        print("MADE SC View Visible")
        
        
    }
        
    }

    
    


extension SetANameOnboarding: UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
}


