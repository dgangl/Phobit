//
//  Memory .swift
//  Phobit
//
//  Created by 73 on 08.02.18.
//  Copyright © 2018 73. All rights reserved.
//

import Foundation
import UIKit

class Memory{
    
    
    public func saveInCluster(input: BillData2, append : Bool, target: UIViewController){
        var clusternumber = UserDefaults.standard.integer(forKey: "cluster")
        if clusternumber == 0{
            UserDefaults.standard.set(1, forKey: "cluster")
            clusternumber = 1
        }
        if(append){
            if var dataInMemory = read(){
                if(dataInMemory.count > App_Settings.CLUSTER_LIMIT){
                    //SAVE IN NEW CLUSTER
                    print("Saving Data in Cluster \(clusternumber) for User \(UserData.getChoosen().email)")
                    dataInMemory.append(input)
                    let encryptedData = NSKeyedArchiver.archivedData(withRootObject: dataInMemory);
                    UserDefaults.standard.set(encryptedData, forKey:  "\(UserData.getChoosen().email) ::: \(clusternumber)")
                    
                }else{
                    clusternumber + 1;
                    print("Saving Data in new Cluster \(clusternumber) for User \(UserData.getChoosen().email)");
                    let encryptedData = NSKeyedArchiver.archivedData(withRootObject: input);
                    //::: as the indetifier for the clusternumber
                    UserDefaults.standard.set(encryptedData, forKey: "\(UserData.getChoosen().email):::\(clusternumber)")
                    UserDefaults.standard.set(clusternumber, forKey: "cluster")
                }
            }
        }
    }
    
    public func readFromCluster() -> [BillData2]! {
        var clusternumber = UserDefaults.standard.integer(forKey: "cluster")
        if(clusternumber == 0){
            clusternumber = 1
        }
        if let encryptedClusterData = UserDefaults.standard.data(forKey: "\(UserData.getChoosen().email) ::: \(clusternumber))"){
            return NSKeyedUnarchiver.unarchiveObject(with: encryptedClusterData) as! [BillData2]
        }else{
            print("Error while reading")
            return nil
        }
    }
    
    public func readEverythingFromCluster() -> [BillData2]! {
        var clusternumber = UserDefaults.standard.integer(forKey: "cluster")
        if clusternumber == 0{
            return readFromCluster();
        }else{
            var data : [BillData2] = []
            for index in 1...clusternumber{
                if let encryptedClusterdata = UserDefaults.standard.data(forKey: "\(UserData.getChoosen().email) ::: \(index))"){
                    let billArray = NSKeyedUnarchiver.unarchiveObject(with: encryptedClusterdata) as! [BillData2]
                    data.append(contentsOf: billArray)
                }
                
            }
            return data
        }
        
    }
    
    public func saveArray(inputArray: [BillData2]){
        let encryptedArray = NSKeyedArchiver.archivedData(withRootObject: inputArray)
        UserDefaults.standard.set(encryptedArray, forKey: String("\(UserData.getChoosen().email)"))
    }
    
    
    /// Sorts your BillData array depending on the Dates of all BillDatas
    ///
    /// - Parameter array_to_sort: your array to be sorted
    /// - Returns: the sorted array
    public func sortBillData(array_to_sort : [BillData2]) -> [BillData2]{
        var array = array_to_sort
//        array.sort(by: {$0.datum.compare($1.datum) == .orderedAscending})
//        return array
        array.sort { (s1, s2) -> Bool in
            return s1.getDate() > s2.getDate()
        }
        return array
    }
    
    public func duplicateProver(input: BillData2) -> Bool{
        var allMems = read()
        
        if let mems = allMems{
            for bill in allMems!{
                if(bill.uuid == input.uuid){
                    return true
                }
            }
        }else{
            return false
        }
        
        return false
    
        
        
    }
    
    
    public func save(input: BillData2, append : Bool, target: UIViewController?){
        
        // adds the new rechnungsersteller to the userdefaults for smart type.
        // newStringForSearch(rechnungsersteller: input.rechnungsersteller)
        
        
        
        //Getting the remaining Billdatas and writing them again
        var data : [BillData2]!
        if(append){
            // will crash if the user didn't save anything before...
            //        data = read()!
            //        data.append(input)
            
            
            // this fix should work around this.
            if let datainmemory = read() {
                data = datainmemory
                if let target = target {
                    if(proveIfLimitReached(billDataArray: datainmemory)){
                        
                        let alert = UIAlertController.init(title: "Rechnungslimit erreicht!", message: "Du hast dein Rechnungslimit erreicht. Mit dem Premium-Versions Abo hast du unlimitierten Zugriff auf alle Features.", preferredStyle: .alert)
                        let okayAlertAction = UIAlertAction.init(title: "Rechnung verwerfen", style: .default, handler: { action in
                            alert.dismiss(animated: true, completion: nil)
                            target.dismiss(animated: true, completion: nil)
                            let encryptedData = NSKeyedArchiver.archivedData(withRootObject: data)
                            
                            //Save to UserDefaults
                            print("Save Data in \(UserData.getChoosen().name)")
                            UserDefaults.standard.set(encryptedData, forKey: String("\(UserData.getChoosen().email)"))
                            
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
                        data.append(input)
                        //Encrypt Data
                        let encryptedData = NSKeyedArchiver.archivedData(withRootObject: data)
                        
                        //Save to UserDefaults
                        print("Save Data in \(UserData.getChoosen().name)")
                        UserDefaults.standard.set(encryptedData, forKey: String("\(UserData.getChoosen().email)"))
                       
                    }
                }else{
                    data.append(input)
                    //Encrypt Data
                    let encryptedData = NSKeyedArchiver.archivedData(withRootObject: data)
                    
                    //Save to UserDefaults
                    print("Save Data in \(UserData.getChoosen().name)")
                    UserDefaults.standard.set(encryptedData, forKey: String("\(UserData.getChoosen().email)"))
                }
            }else{
                target?.dismiss(animated: true, completion: nil)
                data = [input]
                
                
                
                //Encrypt Data
                let encryptedData = NSKeyedArchiver.archivedData(withRootObject: data)
                
                //Save to UserDefaults
                print("Save Data in \(UserData.getChoosen().name)")
                UserDefaults.standard.set(encryptedData, forKey: String("\(UserData.getChoosen().email)"))
            }
        }
    }
    
    /// Löscht alle BillData Objekte aus dem Speicher
    ///
    /// - Parameter lockKey: Key um sicherzugehen das diese Methode nicht unabsichtlich aufgerufen wird
    public func delete(lockKey: String){
        if(lockKey.elementsEqual("heUssdUWnD2331SjsadwSKS")){
        UserDefaults.standard.set(nil, forKey: String(UserData.getChoosen().email))
           
        }
    }
    
    public func read() -> [BillData2]!{
        //Get data from UserDefaults if avaliable
        print("Reading Data in \(UserData.getChoosen().name)")
        
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
        }else{
            return false
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
