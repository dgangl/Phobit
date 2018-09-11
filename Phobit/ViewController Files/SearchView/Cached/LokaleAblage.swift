//
//  LokaleAblage.swift
//  Phobit
//
//  Created by Paul Wiesinger on 10.09.18.
//  Copyright © 2018 LonoS. All rights reserved.
//

import UIKit

class LokaleAblage {
    
    func save(billdata: BillData2, image: UIImage?, target: UIViewController?) {
        if let image = image {
            // add image
            let imageData = ImageData()
            let url = UUID.init().uuidString
            billdata.imageURL = url
            imageData.writeImageTo(name: url, imageToWrite: image)
        }
        
        // saving
        var data = [BillData2]()
        
            if let dataInMemory = read() {
                data = dataInMemory
            }

        
        data.append(billdata)
        let encryptedData = NSKeyedArchiver.archivedData(withRootObject: data)
        UserDefaults.standard.set(encryptedData, forKey: "\(UserData.getChoosen().email)_LOCAL_STORAGE")
    }
    
    // OVERWRITES!!!
    func saveNewArray(billData: [BillData2], target: UIViewController?) {
        let encryptedData = NSKeyedArchiver.archivedData(withRootObject: billData)
        UserDefaults.standard.set(encryptedData, forKey: "\(UserData.getChoosen().email)_LOCAL_STORAGE")
    }
    
    func read() -> [BillData2]? {
        
        if let data = UserDefaults.standard.data(forKey: String("\(UserData.getChoosen().email)_LOCAL_STORAGE")){
            //Decrypt Data and return
            let decryptedData = NSKeyedUnarchiver.unarchiveObject(with: data) as! [BillData2]
            return decryptedData
            
        }else{
            // no user default with this name...
        }
        return nil
    }
    
    func clearCurrentAblage() {
        UserDefaults.standard.removeObject(forKey: "\(UserData.getChoosen().email)_LOCAL_STORAGE")
    }
}
