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
    
   //The UserName of the Database is declared in UserDefaults "DatabaseUserName"
    
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
        
//        db.collection("Daten").addDocument(data: docData)/*Error Handling*/{ err in
//            //Block Start
//            if let _ = err {
//                print("DATABASE=> ERROR WRITING NEW DOCUMENT")
//            } else {
//                print("DATABASE=> WROTE A NEW DOCUMENT SUCCESSFULLY")
//            }
//            //Block end
//        }
        let UserName = UserDefaults.standard.string(forKey: "DatabaseUserName") ?? "";
        
        let messageRef = db
            .collection("Nutzer").document(UserName).collection("Daten").addDocument(data: docData)/*Error Handling*/{ err in
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
    
    func checkUser(name: String, passwort: String, completion: @escaping (Bool)->())  {
        var goAhead = false;
        var endThread = false;
        
        //Try to find the cirtain document
        let docRef = db.collection("Nutzer").document(name);
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                print("Document exists")
                //Document exists! Now we get the values of the Document!
                let values = document.data()?.values;
                
                 //Run through all Datas in the Document
                for val in values!{
                    print("Schleife Start")
                   //Passwort is a String -> If String -> It should be the password!
                    if let test = val as? String{
                        //Is the given Password equals the correct Password?
                        if(test.elementsEqual(passwort)){
                            //THE PASSWORT MATCHED TO OUR USER!
                            print("Matched")
                            //We have to save the UserName for later Use
                            UserDefaults.standard.set(name, forKey: "DatabaseUserName");
                            
                            goAhead = true;
                            endThread = true;
                            completion(goAhead)
                        }
                    }
                }
                print("Schleife Fertig")
                endThread = true;
                completion(goAhead);
            } else {
                
                endThread = true;
                //There is no User with this name
                print("Document does not exist")
                completion(goAhead);
            }
        }
        
    }
    
    func setTheNameForTheUser(nameOfTheUser: String) {
        let userName = UserDefaults.standard.string(forKey: "DatabaseUserName") ?? "";
        db.collection("Nutzer").document(userName).updateData(["Name" : nameOfTheUser]);
    }
    
   
    
}
