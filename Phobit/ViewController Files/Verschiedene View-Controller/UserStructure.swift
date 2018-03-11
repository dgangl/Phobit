//
//  UserStructure.swift
//  Phobit
//
//  Created by Paul Krenn on 05.02.18.
//  Copyright © 2018 Paul Wiesinger. All rights reserved.
//

import Foundation

class UserStructure: NSObject, NSCoding {
    var name = "";
    var passwort = "";
    var loginDate = Date();
    init(name: String, passwort: String, loginDate: Date) {
        self.name = name;
        self.passwort = passwort;
        self.loginDate = loginDate;
        
    }
    
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(passwort, forKey: "passwort");
        aCoder.encode(loginDate, forKey: "loginDate")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        self.passwort = aDecoder.decodeObject(forKey: "passwort") as? String ?? ""
        self.loginDate = (aDecoder.decodeObject(forKey: "loginDate") as? Date)!
    }
    
    
    
    
    
}
