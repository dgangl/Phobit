//
//  CustomFormat.swift
//  Phobit
//
//  Created by Paul Wiesinger on 22.01.18.
//  Copyright © 2018 Paul Wiesinger. All rights reserved.
//

import Foundation


class CFormat {
// WARNING: No error handling right now here.
    
    
    static func correctProzentKomma(zahl: String) ->String {
        
        let newzahl = zahl.replacingOccurrences(of: ",", with: ".")
        let number = Double(newzahl)
        
        var twoDecimalPlaces = String(format: "%.0f", number!)
        twoDecimalPlaces = twoDecimalPlaces + "%";
        
        return twoDecimalPlaces.replacingOccurrences(of: ".", with: ",")
    }
    
    
    static func correctGeldbetrag(zahl: String) -> String{
        let newzahl = zahl.replacingOccurrences(of: ",", with: ".")
        let number = Double(newzahl)
        
        let twoDecimalPlaces = String(format: "%.2f", number!)
        
        return twoDecimalPlaces.replacingOccurrences(of: ".", with: ",")
    }
    
    
    static func correctStringToDouble(zahl: String) -> Double {
        let newZahl = zahl.replacingOccurrences(of: ",", with: ".")
        return Double(newZahl)!
    }
    
    static func getDateFromString(datum: String) -> Date {
        let df = DateFormatter()
        df.dateFormat = "d.M.yyyy"
        return df.date(from: datum)!
    }
}
