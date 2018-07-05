//
//  BillData2.0.swift
//  Phobit
//
//  Created by Julian Kronlachner on 16.02.18.
//  Copyright © 2018 Paul Wiesinger. All rights reserved.
//

import Foundation
import UIKit

struct Item{
    var changes = false
    var value: String
    var description: String?
    // initializer
    init(value: String, description: String?) {
        self.value = value
        self.description = description
    }
}


class BillData2: NSObject, NSCoding {
    //VARS AND LETS
    var steuerzeilen : [Steuerzeile] = [Steuerzeile]()
    var gesamtBrutto: Double = 0.0
    var datum : String = ""
    var rechnungsersteller: String = ""
    var kontierung: String = ""
    var bezahlung: String = ""
    var imageURL: String = ""
    var uploaded: Bool = false
    var uuid : String = ""
    
    //ENCODE
    func encode(with aCoder: NSCoder) {
        aCoder.encode(steuerzeilen, forKey: "steuerzeilen")
        aCoder.encode(gesamtBrutto, forKey: "gesamtBrutto")
        aCoder.encode(kontierung, forKey: "kontierung")
        aCoder.encode(rechnungsersteller, forKey: "name")
        aCoder.encode(datum, forKey: "datum")
        aCoder.encode(bezahlung, forKey: "bezahlung")
        aCoder.encode(imageURL, forKey: "url")
        aCoder.encode(uploaded, forKey: "status")
        aCoder.encode(uuid, forKey: "uuid")
    }
    //DECODE
    required init?(coder aDecoder: NSCoder) {
        self.gesamtBrutto = Double(aDecoder.decodeDouble(forKey: "gesamtBrutto"))
        self.steuerzeilen = aDecoder.decodeObject(forKey: "steuerzeilen") as! [Steuerzeile]
        self.kontierung = aDecoder.decodeObject(forKey: "kontierung") as? String ?? ""
        self.rechnungsersteller = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        self.datum = aDecoder.decodeObject(forKey: "datum") as? String ?? ""
        self.bezahlung = aDecoder.decodeObject(forKey: "bezahlung") as? String ?? ""
        self.imageURL = aDecoder.decodeObject(forKey: "url") as? String ?? ""
        self.uploaded = aDecoder.decodeBool(forKey: "status")
        self.uuid = aDecoder.decodeObject(forKey: "uuid") as? String ?? ""
        
    }
    
    
    //STANDARD INIT
    init(steuerzeilen: [Steuerzeile], gesamtBrutto: Double, datum : String, rechnungsersteller: String, kontierung: String, bezahlung: String) {
        self.steuerzeilen = steuerzeilen
        self.gesamtBrutto = gesamtBrutto
        self.datum = datum
        self.rechnungsersteller = rechnungsersteller
        self.kontierung = kontierung
        self.bezahlung = bezahlung
        
    }
    //New Init
    init(steuerzeilen: [Steuerzeile], gesamtBrutto: Double, datum : String, rechnungsersteller: String, kontierung: String, bezahlung: String, uploaded: Bool, uuid: String) {
        self.steuerzeilen = steuerzeilen
        self.gesamtBrutto = gesamtBrutto
        self.datum = datum
        self.rechnungsersteller = rechnungsersteller
        self.kontierung = kontierung
        self.bezahlung = bezahlung
        self.uploaded = uploaded
        self.uuid = uuid
    }
    
    //EMPTY INIT
    init(_: Double){
        
    }
    
    
    //////////////////////
    // sample data init //
    //////////////////////
    
    init(datum: String, rechnungsersteller: String, kontierung: String, bezahlung: String) {
        self.datum = datum
        self.rechnungsersteller = rechnungsersteller
        self.kontierung = kontierung
        self.bezahlung = bezahlung
    }
}





// Table View thing

extension BillData2 {
    
    public func getTableDict() -> [IndexPath:Any] {
        var dict = [IndexPath:Any]()
        dict[IndexPath.init(row: 0, section: 0)] = Item.init(value: rechnungsersteller, description: nil)
        dict[IndexPath.init(row: 0, section: 1)] = Item.init(value: datum, description: "Datum")
        
        // steuern
        steuerzeilen.sort { (s1, s2) -> Bool in
            return s1.getProzent() < s2.getProzent()
        }
        
        var counter = 1
        
        for steuerzeile in steuerzeilen {
            dict[IndexPath.init(row: counter, section: 2)] = steuerzeile
            counter += 1
        }
        
        dict[IndexPath.init(row: 0, section: 3)] = Item.init(value: kontierung, description: nil)
        dict[IndexPath.init(row: 0, section: 4)] = Item.init(value: bezahlung, description: nil)
        
        return dict
    }
    
    public func getNumberOfSteuerzeilen() -> Int {
        return steuerzeilen.count
    }
    
    
    public func merchChanges(tableDict: [IndexPath:Any]) {
        // first two items
        for number in 0...1 {
            let object = tableDict[IndexPath.init(row: 0, section: number)] as! Item
            
            
            if number == 0 {
                rechnungsersteller = object.value
            } else if number == 1 {
                datum = object.value
            }
            
        }
        
        // now checking the steuerzeilen, with flex-size
        if(!steuerzeilen.isEmpty){
        for number in 1...(steuerzeilen.count) {
            let object = tableDict[IndexPath.init(row: number, section: 2)] as! Steuerzeile
            steuerzeilen[number - 1] = object
            }
            
        }
        
        for number in 3...4 {
            let object = tableDict[IndexPath.init(row: 0, section: number)] as! Item
            
            
            
            if number == 3 {
                kontierung = object.value
            } else if number == 4 {
                bezahlung = object.value
            }
            
        }
        
        print("--------------------")
        print(rechnungsersteller)
        print(datum)
        print(steuerzeilen)
        print(kontierung)
        print(bezahlung)
        print("--------------------")
    }
    
   

    public func getDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        if(datum.elementsEqual("Datum eingeben")){return Date.init()}
        return dateFormatter.date(from: datum)!
    }
}

