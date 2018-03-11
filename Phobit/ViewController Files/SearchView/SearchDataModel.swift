//
//  SearchDataModel.swift
//  Phobit
//
//  Created by Paul Wiesinger on 06.01.18.
//  Copyright © 2018 Paul Wiesinger. All rights reserved.
//

import Foundation

class SearchDataModel {
    var firma: String
    var bruttoBetrag: String
    var datum: String
    
    var billData: BillData
    
    
    // the ID in the dict in the ViewController
    var dictID: Int
    
    init(firma: String, bruttoBetrag: String, datum: String, dictID: Int, billData: BillData) {
        self.firma = firma
        self.bruttoBetrag = ""
        self.datum = datum
        self.dictID = dictID
        self.billData = billData
        
        
        self.bruttoBetrag = correctComma(zahl: bruttoBetrag)
    }
    
    
    func correctComma(zahl: String) -> String {
        let newzahl = zahl.replacingOccurrences(of: ",", with: ".")
        let number = Double(newzahl)
        var twoDecimalPlaces = ""
        
        twoDecimalPlaces = String(format: "%.2f", number!);
        
        
        twoDecimalPlaces = twoDecimalPlaces.replacingOccurrences(of: ".", with: ",")
        return twoDecimalPlaces + " €";
    }
    
    
    // returns a value for the date, to compare them.
    func getDateValue() -> Int {
        let splitedArr = datum.components(separatedBy: ".")
        
        let tag = Int(splitedArr[0])!
        let monat = Int(splitedArr[1])! * 31
        let jahr = Int(splitedArr[2])! * 1000
        
        return (tag + monat + jahr)
    }
}
