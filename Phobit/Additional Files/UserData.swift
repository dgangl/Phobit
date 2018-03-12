//
//  UserStructure.swift
//  Phobit
//
//  Created by Paul Krenn on 05.02.18.
//  Copyright © 2018 Paul Wiesinger. All rights reserved.
//

import Foundation

class UserData: NSObject, NSCoding {
    var name = "";
    var email = "";
    var passwort = "";
    var loginDate = Date();
    init(name: String,email: String, passwort: String, loginDate: Date) {
        self.email = email;
        self.name = name;
        self.passwort = passwort;
        self.loginDate = loginDate;
        
    }
    
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(email, forKey: "email")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(passwort, forKey: "passwort");
        aCoder.encode(loginDate, forKey: "loginDate")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.email = aDecoder.decodeObject(forKey: "email") as? String ?? ""
        self.name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        self.passwort = aDecoder.decodeObject(forKey: "passwort") as? String ?? ""
        self.loginDate = (aDecoder.decodeObject(forKey: "loginDate") as? Date)!
    }
    
    
    static func getChoosen() -> UserData {
        
        //ENCODING ARRAY START//
        var thisArray: [UserData] = [];
        if let data = UserDefaults.standard.data(forKey: "UserData"),
            let test = NSKeyedUnarchiver.unarchiveObject(with: data) as? [UserData] {
            thisArray = test;
        } else {
            print("There is an issue with reading the User Defaults / USER STRUCTURE")
        }
        if(thisArray == nil){
            let testUser = UserData.init(name: "Demo Benutzer", email: "demomail@test.com", passwort: "DEMO", loginDate: Date.init());
            return testUser;
        }
        
        return thisArray[0];
    }
    
    static func getWholeArray() -> [UserData]{
        //ENCODING ARRAY START//
        var thisArray: [UserData] = [];
        if let data = UserDefaults.standard.data(forKey: "UserData"),
            let test = NSKeyedUnarchiver.unarchiveObject(with: data) as? [UserData] {
            thisArray = test;
        } else {
            print("There is an issue with reading the User Defaults / USER STRUCTURE")
        }
        
        return thisArray;
        
        
    }
    
    //Returns wheather the newUser is already used
    static func addAccount(newUser: UserData) -> Bool{
        let thisUser = newUser;
        
        var nsarr: [UserData] = [];
        
        if let data = UserDefaults.standard.data(forKey: "UserData"),
            let test = NSKeyedUnarchiver.unarchiveObject(with: data) as? [UserData] {
            nsarr = test;
        } else {
            print("There is an issue")
        }
        
        var isTaken = false;
        
        for test in nsarr{
            
            if(thisUser == test){
                return false;
            }
            
        }
        if(isTaken == false){
            
            
            nsarr.append(thisUser);
            let encodedData = NSKeyedArchiver.archivedData(withRootObject: nsarr)
            UserDefaults.standard.set(encodedData, forKey: "UserData");
            
            
            return true;
        }
        
       
        
        
        
    }
    static func saveNew(newArray: [UserData]){
        
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: newArray)
        UserDefaults.standard.set(encodedData, forKey: "UserData");
        
    }
    
    
    
    
}
