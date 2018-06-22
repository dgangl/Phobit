//
//  Database.swift
//  Notically
//
//  Created by Paul Krenn on 24.04.18.
//  Copyright © 2018 Paul Krenn. All rights reserved.
//

import Foundation
import FirebaseFirestore


class Database{

    let db:Firestore;
    
   //The UserName of the Database is declared in UserDefaults "DatabaseUserName"
    
    init() {
        db = Firestore.firestore();
        
    }
    
    func addNew(wholeString: String?, companyName: String, Date: Date, Brutto: Double, Netto: Double, TenProzent: Double,ThirteenProzent : Double, NineteenProzent : Double, TwentyProzent: Double, Kontierung: String ) {
        
        let userName = UserDefaults.standard.string(forKey: "DatabaseUserName") ?? "";
        
        //If no OCR Text is here - do not upload
        if(wholeString == nil){
            return;
        }
        
        //Setting the Document
        let docData: [String: Any] = [
            "wholeString" : wholeString ?? "",
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
        
        db.collection("Nutzer").document(userName).collection("Daten").addDocument(data: docData)/*Error Handling*/{ err in
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
                goAhead = false;
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
    
    func getDicOfData(completion: @escaping ([String : [String : Any]]) -> ()) {
        var dictionary: [String: [String:Any]] = [:];
        db.collection("Daten").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    
                    dictionary[UUID.init().uuidString] = document.data();
                    
                }
                completion(dictionary);
            }
            
            
        }
    }
    
    func getDicOfUser() -> [String : Any]{
        var names : [String] = [];
        var sucCollected : Bool = false;
        var dictionary: [String:Any] = [:];
        
        db.collection("Nutzer").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("Running through the names")
                    for doc in document.data(){
                        
                        names.append(doc.key);
                    }
                    print("Got the Users Name")
                    sucCollected = true;
                }
            }
            
        }
        
        while(sucCollected != true){
            sleep(3);
            print("Waiting for the Users Name")
        }
        var counter : Int = 0;
        
        for nutzer in names{
            
            db.collection("Nutzer").document(nutzer).collection("Daten").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        for doc in document.data(){
                            dictionary[doc.key] = doc.value;
                        }
                    }
                }
                counter = counter + 1;
                print("Read a Doc")
            }
            
        }
        
        while(counter <= names.count){
            
            sleep(3);
            print("Waiting for the DATAS")
            
        }
        
        return dictionary;
        
    }
   
    
    }

