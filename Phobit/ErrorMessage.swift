//
//  ErrorMessage.swift
//  Phobit
//
//  Created by Julian Kronlachner on 27.01.18.
//  Copyright © 2018 Paul Wiesinger. All rights reserved.
//

import Foundation
import UIKit

class ErrorMessage{
    
    
    
    @IBAction func showAlertButtonTapped(_ sender: UIButton) {
    
    // create the alert
    let alert = UIAlertController(title: "My Title", message: "This is my message.", preferredStyle: UIAlertControllerStyle.alert)
    
    // add an action (button)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
    
    // show the alert
    self.present(alert, animated: true, completion: nil)
    }
    
    
    
}


