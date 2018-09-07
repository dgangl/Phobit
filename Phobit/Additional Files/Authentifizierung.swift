//
//  Authentifizierung.swift
//  Phobit
//
//  Created by Paul Wiesinger on 10.08.18.
//  Copyright © 2018 LonoS. All rights reserved.
//

import UIKit
import LocalAuthentication

class Authentifizierung {
    
    static func getAuthStatus() -> Bool {
        return UserDefaults.standard.bool(forKey: "slider")
    }
    
    
    static func authentifizierung(segue : String, target: UIViewController) {
        
        let myContext = LAContext()
        let myLocalizedReasonString = "Authentifiziere dich, um fortzufahren."
        var authError: NSError?
        
        if myContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: &authError) {
            myContext.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: myLocalizedReasonString) { success, evaluateError in
                if success {
                    DispatchQueue.main.async {
                        // Code did match
                        //target.performSegue(withIdentifier: segue, sender: target)
                    }
                } // else code did not match
            }
        } else {
            // No code on iPhone set... we continue...
            //target.performSegue(withIdentifier: segue, sender: target)
        }
    }
    
    static func scrollAndCheck(toID id: Int) {
        if getAuthStatus() == true {
            let myContext = LAContext()
            let myLocalizedReasonString = "Authentifiziere dich, um fortzufahren."
            var authError: NSError?
            
            if myContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: &authError) {
                myContext.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: myLocalizedReasonString) { success, evaluateError in
                    if success {
                        DispatchQueue.main.async {
                            // Code did match
                            AppDelegate.snapContainer.scrollToPage(id)
                        }
                    } // else code did not match
                }
            } else {AppDelegate.snapContainer.scrollToPage(id)
                // No code on iPhone set... we continue...
                AppDelegate.snapContainer.scrollToPage(id)
            }
        } else {
            AppDelegate.snapContainer.scrollToPage(id)
        }
    }
}
