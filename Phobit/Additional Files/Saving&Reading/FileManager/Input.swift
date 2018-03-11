//
//  Input.swift
//  Phobit
//
//  Created by LonoS on 23.12.17.
//  Copyright © 2017 LonoS. All rights reserved.
//

import Foundation

class Input{
    let filemanager = File()
    var filename : String = "history.csv";
    
    /*
    func setFilename(filename : String){
        self.filename = filename
    }
    */
    
    func inputToDict(filename : String) -> [Int : [String]]?{
        //2D Dictionary
        var dict: [Int : [String]]?
        var count = 0
        
        
        
        if let longDataString = filemanager.readFile(filename: filename) {
            
            dict = [Int : [String]]()
            //Splits in Bills
            var splittedLongDataString = longDataString.components(separatedBy: "\\")
            
            // to remove the last element wich would be ""
            splittedLongDataString.remove(at: splittedLongDataString.count-1)
            
            for splittedData in splittedLongDataString{
                //Splits bills to data
                dict![count] = splittedData.components(separatedBy: ";")
                count = count + 1
            }
        }
        return dict
        
        
    }
    
    /*
     useless, only returns the first Object.
     
     func getPreview() -> [String]{
     let DateDict = inputToDict(filename: filename)
     return DateDict![0]!
     }
     
     */
    
    
     func getDetail(forRow : Int) -> [String]? {
        if let DateDict = inputToDict(filename: filename) {
            if forRow < DateDict.count {
                return DateDict[forRow]!
            }
        }
            return nil
        
     }
     
    
    //inputToDictPrem is not finished! Do not use!
    
    /*
     
     
        useless... at least now.
     
     
     
    func inputToDictPrem(){
        
        ///////////////////////////
        //UNFINISHED! DO NOT USE!//
        ///////////////////////////
        
        
        //Input to Premium Dictionary inputs our normal Dictionary to a Dictionary with Keys. If this is finished you can get the date like this:
        //let string : String = yourDict[row, "Date"]
        //But this wasn't tested!
        //For secure use use the normal input to Dictionary Function!
        
        
        
        
        
        if let longDataString = filemanager.readFile(filename: filename) {
        var dict : [Int : [String]]?
        let splitToBills = longDataString.components(separatedBy: "//")
        var count = 0
        var strCount = 0
        for splittedBill in splitToBills{
            dict![count] = splittedBill.components(separatedBy: ";")
            
            for strings in dict![count]!{
                
                var name : String
                var strdict : [String : String]!
                switch(strCount){
                case 1:
                    name = "Datum"
                    break
                case 2:
                    name = "Name"
                    break
                case 3:
                    name = "Steuersatz"
                    break
                default:
                    name = "Unnamed"
                    break
                    
                }
                
                strdict[name] = strings
                strCount = strCount + 1
                
            }
            count = 0
            count = count + 1
            
        }
        
    }
    
    */
}
