//
//  ViewController.swift
//  newLoginScreen
//
//  Created by Paul Krenn on 07.03.18.
//  Copyright © 2018 Paul Krenn. All rights reserved.
//

import UIKit

class SetANameOnboarding: UIViewController {
    
    @IBOutlet weak var TextField: UITextField!
    @IBOutlet weak var goOn: UIButton!
    @IBOutlet weak var FehlerMeldung: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        goOn.layer.cornerRadius = 10;
        TextField.becomeFirstResponder();
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func checkIt(_ sender: Any) {
        print("checkStringLength called")
        if(TextField.text == nil){
            return
        }
        var text = TextField.text!
        if(text.count >= 20){
            
            FehlerMeldung.isHidden = false;
            
            text.removeLast();
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
        if(TextField.text == nil){
            return
        }
        var users = UserData.getWholeArray();
        let actual = users.popLast()
        actual?.name = TextField.text!;
        users.append(actual!);
        
        //Check later wheater the Account is already used!
        if(true){
            UserData.saveNew(newArray: users)
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
        }
        
    }
    
    
    



