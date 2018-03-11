//
//  SampleDataLoader.swift
//  Phobit
//
//  Created by Paul Wiesinger on 07.03.18.
//  Copyright © 2018 LonoS. All rights reserved.
//

import Foundation


class SampleDataLoader {
    
    static func loadSampleData() {
        var rawData = [String]()
        let path = Bundle.main.path(forResource: "sampleData", ofType: "txt")
        do {
            let rawStrings = try String(contentsOfFile: path!, encoding: .utf8)
            rawData = rawStrings.components(separatedBy: .newlines)
        } catch {
            print(error)
        }
        
        rawData.removeLast()
        var billData = [BillData2]()
        
        
        for rawString in rawData {
            print(rawString)
            let rawSplit = rawString.components(separatedBy: "[")
            let steuerzeile = extractSteuer(rawString: rawSplit.last!)
            let bill = extractBillData(rawString: rawSplit.first!)
            bill.steuerzeilen = [steuerzeile]
            bill.gesamtBrutto = steuerzeile.getBrutto()
            billData.append(bill)
        }
        
        let mem = Memory()
        
        for bill in billData {
            mem.save(input: bill, append: true)
        }
    }
    
    
    private static func extractSteuer(rawString: String) -> Steuerzeile {
        var splittedArray = rawString.components(separatedBy: "#;#")
        splittedArray[0] = splittedArray[0].replacingOccurrences(of: "#", with: "")
        splittedArray[splittedArray.count-1] = (splittedArray.last?.replacingOccurrences(of: "#]#", with: ""))!
        
        
        return Steuerzeile(prozent: Int(Double(splittedArray[0])!), prozentbetrag: Double(splittedArray[2])!, netto: Double(splittedArray[1])!, brutto: Double(splittedArray[3])!)
    }
    
    
    private static func extractBillData(rawString: String) -> BillData2 {
        var splittedArray = rawString.components(separatedBy: "#;#")
        splittedArray[splittedArray.count-1] = (splittedArray.last?.replacingOccurrences(of: "#", with: ""))!
        
        return BillData2.init(datum: splittedArray[1], rechnungsersteller: splittedArray[0].replacingOccurrences(of: "\"", with: ""), kontierung: splittedArray[3], bezahlung: splittedArray[2])
    }
 
}
