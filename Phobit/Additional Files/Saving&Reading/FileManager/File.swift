//
//  File.swift
//  Phobit
//
//  Created by LonoS on 23.12.17.
//  Copyright © 2017 LonoS. All rights reserved.
//

import Foundation
import UIKit


class File{
    
    let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    
    
    func saveFile(line: String, append: Bool, filename: String){
        var line = line
        let fileURL = dir!.appendingPathComponent(filename)
        if(append == false){
            
            
            
            do {
                try line.write(to: fileURL, atomically: false, encoding: .utf8)
                print("Sucsess")
            }
            catch {
                print("Error")
            }
        }else{
            
            do {
                
                // if someting is saved readFile will return a String, else it will return nil.
                if let text = readFile(filename: filename) {
                    line += text
                }
                
                
                try line.write(to: fileURL, atomically: false, encoding: .utf8)
                print("Sucsess")
                print(readFile(filename: "history.csv"))
                
            }catch{
                print("Error")
            }
            
            
        }
        
    }
    
    func saveDataToUserDefaults(savingItem : BillData, identifier : String){
        let userDefaults = UserDefaults.standard
        userDefaults.set(savingItem, forKey: identifier)
    }
    
    func readDataFromUserDefaults(identifier : String) -> BillData{
        let userDefaults = UserDefaults.standard
        return userDefaults.object(forKey: identifier)! as! BillData
        
    }
    
    
    // optional because if nothing is saved, we return nil
    func readFile(filename : String) -> String? {
        
        let fileURL = dir!.appendingPathComponent(filename)
        do{
            
            let line = try String(contentsOf: fileURL, encoding: .utf8)
            return line
            
        } catch {
            return nil
        }
        
    }
    
    
}

