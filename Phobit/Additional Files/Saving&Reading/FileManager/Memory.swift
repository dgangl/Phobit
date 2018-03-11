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
        print("Save Data in \(UserData.getChoosen().email)")
        UserDefaults.standard.set(encryptedData, forKey: String("\(UserData.getChoosen().email)"))
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
    
    
    
    
    
    
    
    
    
    
    
}
