//
//  OnboardingController.swift
//  OnboardingScreen
//
//  Created by Paul Krenn on 12.01.18.
//  Copyright © 2018 Paul Krenn. All rights reserved.
//

import UIKit

class OnboardingController: UIViewController {
    //TextFields//
    @IBOutlet weak var NameBenutzer: UITextField!
    @IBOutlet weak var CodeBenutzer: UITextField!
    //Buttons//
    @IBOutlet weak var Login: UIButton!
    @IBOutlet weak var Skip: UIButton!
    //Labels//
    @IBOutlet weak var AchtungLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Login.layer.cornerRadius = 10
        Skip.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
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
    @IBAction func continuetouched(_ sender: UIButton) {
        
        
        // this actually triggers the SIGBRT
        
        //        UserDefaults.setValue(NameBenutzer.text, forKey: "name")
        
        // try out this
        if(NameBenutzer.text == "" || CodeBenutzer.text == ""){
            AchtungLabel.isHidden = false
        }
        else{
            UserDefaults.standard.set(NameBenutzer.text, forKey: "name")
            performSegue(withIdentifier: "toStart", sender: nil)
        }
        
        
    }
    @IBAction func skipTouched(_ sender: Any) {
        performSegue(withIdentifier: "toStart", sender: nil)
    }
    @IBAction func goOn(_ sender: Any) {
        self.NameBenutzer.resignFirstResponder()
        self.CodeBenutzer.resignFirstResponder()
    }
    
    
    
}

