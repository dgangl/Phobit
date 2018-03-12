//
//  Memory .swift
//  Phobit
//
//  Created by Julian Kronlachner on 08.02.18.
//  Copyright © 2018 Paul Wiesinger. All rights reserved.
//

import Foundation
import UIKit

class Memory{
    
    
    public func save(input: BillData2, append : Bool, target: UIViewController?){
        
        
        //Getting the remaining Billdatas and writing them again
        var data = [input]
        if(append){
            // will crash if the user didn't save anything before...
            //        data = read()!
            //        data.append(input)
            
            
            // this fix should work around this.
            if let datainmemory = read() {
                data = datainmemory
                if let target = target {
                    if(proveIfLimitReached(billDataArray: datainmemory)){
                        
                        let alert = UIAlertController.init(title: "Rechnungslimit erreicht!", message: "Du hast dein Rechnungslimit erreicht. Kaufe nun die Premium-Version um unlimitierten Zugriff auf alle Features zu haben.", preferredStyle: .alert)
                        let okayAlertAction = UIAlertAction.init(title: "Okay", style: .default, handler: { action in
                            alert.dismiss(animated: true, completion: nil)
                            target.dismiss(animated: true, completion: nil)
                        })
                        let buyPremiumVersion = UIAlertAction.init(title: "Premiumversion kaufen", style: .cancel, handler: { action in
                            print("Premiumversion")
                            //TODO: Premiumversion handeler
                            alert.dismiss(animated: true, completion: nil)
                            target.dismiss(animated: true, completion: nil)
                        })
                        alert.addAction(okayAlertAction)
                        alert.addAction(buyPremiumVersion)
                        target.present(alert, animated: true, completion: nil)
                        
                    }else{
                        target.dismiss(animated: true, completion: nil)
                        target.dismiss(animated: true, completion: nil)

                        data.append(input)
                        
                        
                        
                        //Encrypt Data
                        let encryptedData = NSKeyedArchiver.archivedData(withRootObject: data)
                        
                        //Save to UserDefaults
                        print("Save Data in \(UserData.getChoosen().email)")
                        UserDefaults.standard.set(encryptedData, forKey: String("\(UserData.getChoosen().email)"))
                    }
                }
            }
        }
    }
    
    public func delete(){
        UserDefaults.standard.set(nil, forKey: String(UserData.getChoosen().hash))
    }
    
    public func read() -> [BillData2]!{
        //Get data from UserDefaults if avaliable
        print("Reading Data in \(UserData.getChoosen().email)")
        
        if let data = UserDefaults.standard.data(forKey: String("\(UserData.getChoosen().email)")){
            
            //Decrypt Data and return
            let decryptedData = NSKeyedUnarchiver.unarchiveObject(with: data) as! [BillData2]
            return decryptedData
            
        }else{
            //Fehler
            print("<error>. Something went wrong! Speichersystem konnte nichts auslesen (normal beim ersten starten)")
        }
        return nil
    }
    
    public func proveIfLimitReached(billDataArray: [BillData2])-> Bool{
        if(billDataArray.count >=  App_Settings.Bill_Limit && UserData.getChoosen().name.elementsEqual("Demo Benutzer")){
            return true
        }
        return false
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
