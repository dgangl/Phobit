//
//  AuswertungTFDelegate.swift
//  Phobit
//
//  Created by Paul Wiesinger on 27.01.18.
//  Copyright © 2018 LonoS. All rights reserved.
//

import UIKit


extension NEWAuswertungsTableViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print(string)
        return true
    }
}
