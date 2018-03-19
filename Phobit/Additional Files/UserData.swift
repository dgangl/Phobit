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
    
    static var FIXED_DEMO_USER: UserData = UserData.init(name: "tempo", email: "temp", passwort: "temp", loginDate: Date.init());
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
    
    
    /// Use This Function to get the current choosen User!
    /// If there is no User declared, you will get back a Default User with sample Datas!
    /// - Returns: current choosen User / Demo User
    static func getChoosen() -> UserData {
        
        //ENCODING ARRAY START//
        var thisArray: [UserData] = [];
        if let data = UserDefaults.standard.data(forKey: "UserData"),
            let test = NSKeyedUnarchiver.unarchiveObject(with: data) as? [UserData] {
            thisArray = test;
        } else {
            print("There is an issue with reading the User Defaults / USER STRUCTURE")
        }
        
        
        return thisArray[0];
    }
    
    /// You will get the whole Array out of the User Defaults
    /// Changes won't be applied when you use this value!
    /// Call *UserData.saveNew* to apply your change
    /// - Returns: all Useres (Array) / nil
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
    
    
    /// Adds the User to the Array and saves it into UserDefaults
    ///
    /// - Parameter newUser: a new - already declared User
    /// - Returns: true when there is no same User
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
            
            nsarr.insert(thisUser, at: 0);
            let encodedData = NSKeyedArchiver.archivedData(withRootObject: nsarr)
            UserDefaults.standard.set(encodedData, forKey: "UserData");
            
            
            return true;
        }
        
       
        
        
        
    }
    
    /// Use this Method to save a new UserData Array into UserDefaults.
    /// The old one will be overwritten.
    /// - Parameter newArray: The new Array you want to save
    static func saveNew(newArray: [UserData]){
        
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: newArray)
        UserDefaults.standard.set(encodedData, forKey: "UserData");
        
    }
    
    static func deleteUser(index: Int) -> Bool{
        
        var array = getWholeArray();
        if(array[index].isEqual(FIXED_DEMO_USER)){
            return false;
        }
        array.remove(at: index);
        saveNew(newArray: array);
        return true;
        
    }
    
    
}
