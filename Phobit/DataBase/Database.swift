//
//  Database.swift
//  Notically
//
//  Created by Paul Krenn on 24.04.18.
//  Copyright © 2018 Paul Krenn. All rights reserved.
//

import Foundation
import Firebase
class Database {
    let db:Firestore;
    
    
    init() {
        db = Firestore.firestore();
    }
    
    func addNew(wholeString: String, companyName: String, Date: Date, Brutto: Double, Netto: Double, TenProzent: Double,ThirteenProzent : Double, NineteenProzent : Double, TwentyProzent: Double, Kontierung: String ) {
        //Setting the Document
        let docData: [String: Any] = [
            "wholeString" : wholeString,
            "companyName" : companyName,
            "Date" : Date,
            "Brutto" : Brutto,
            "Netto" : Netto,
            "10 Prozent" : TenProzent,
            "13 Prozent" : ThirteenProzent,
            "19 Prozent" : NineteenProzent,
            "20 Prozent" : TwentyProzent,
            "Kontierung" : Kontierung,
            
        ]
        
        db.collection("Daten").addDocument(data: docData)/*Error Handling*/{ err in
            //Block Start
            if let _ = err {
                print("DATABASE=> ERROR WRITING NEW DOCUMENT")
            } else {
                print("DATABASE=> WROTE A NEW DOCUMENT SUCCESSFULLY")
            }
            //Block end
        }
    }
    
    func getWholeString() -> [String] {
        var array : [String] = [String]();
        let dispatch = DispatchGroup();
        
        DispatchQueue.global().sync {
            db.collection("Daten").getDocuments() { (querySnapshot, err) in
                if let _ = err {
                    print("DATABASE=> ERROR Reading NEW DOCUMENT")
                } else {
                    print("Successfully connected to the DATABASE")
                    for document in querySnapshot!.documents {
                        dispatch.enter();
                        var dictionary = document.data();
                        let stringAll = dictionary.removeValue(forKey: "wholeString") as? String;
                        print("Adding new String to Array")
                        array.append(stringAll!);
                        dispatch.leave();
                    }
                    print("Read all Datas")
                }
            }
            print("got Out 1")
        }
        
        return array;
    }
    
}
