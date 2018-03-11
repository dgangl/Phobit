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
    private enum speicherort : String{
        case standart = "standart"
        case hidden = "hidden"
    }
    
    public func save(input: BillData2, append : Bool){
        //Getting the remaining Billdatas and writing them again
        var data = [input]
        if(append){
            // will crash if the user didn't save anything before...
//        data = read()!
//        data.append(input)
            
            
            // this fix should work around this.
            if let datainmemory = read() {
                data = datainmemory
                data.append(input)
            }
        }
        
        
        //Encrypt Data
        let encryptedData = NSKeyedArchiver.archivedData(withRootObject: data)
        
        //Save to UserDefaults
        UserDefaults.standard.set(encryptedData, forKey: speicherort.standart.rawValue)
    }
    
    public func delete(){
        UserDefaults.standard.set(nil, forKey: speicherort.standart.rawValue)
    }
    
    public func read() -> [BillData2]!{
        //Get data from UserDefaults if avaliable
        if let data = UserDefaults.standard.data(forKey: speicherort.standart.rawValue){
            
            //Decrypt Data and return
            let decryptedData = NSKeyedUnarchiver.unarchiveObject(with: data) as! [BillData2]
            return decryptedData
            
        }else{
            //Fehler
            print("Fehler. Something went wrong! Speichersystem konnte nichts auslesen (normal beim ersten starten)")
        }
        return nil
    }
    
    
    
    
    
    
    
    
    
    
    
}
