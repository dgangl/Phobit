//
//  File.swift
//  Phobit
//
//  Created by Julian Kronlachner on 11.01.18.
//  Copyright © 2018 Paul Wiesinger. All rights reserved.
//

import Foundation
class QRSplitter{
    
    static func split(qrCode: String) -> BillData2 {
//        let bill = BillData(0.0)
        //MARK: ARRAYS
       
        var steuersatzArr = [20.0, 10.0, 13.0, 0.0, 19.0]
        var steuerBetragArr = [0.0, 0.0, 0.0, 0.0, 0.0]
        var steuersatzDiv = [120.0, 110.0, 113.0, 0.0, 119.0]
        var betragsArrDouble : [Double] = [0.0, 0.0, 0.0, 0.0, 0.0]
        
        //MARK: Vars
        var gesamtBrutto : Double = 0.0
        var gesamtNetto : Double = 0.0
        
        
        
        //MARK: Splitting
        let qrCodeArr = qrCode.components(separatedBy: "_")
        var temp = qrCodeArr[4].components(separatedBy: "T")
        let tempo = temp[0].replacingOccurrences(of: "-", with: ".")
        let datum = tempo.components(separatedBy: ".")
        let fertigDatum = datum[2] + "." + datum[1] + "." + datum[0];
        
        
        
        
        //BETRAGS Array
        var betragsArrString = [qrCodeArr[5], qrCodeArr[6], qrCodeArr[7], qrCodeArr[8], qrCodeArr[9]]
        
        var count = 0;
        //"," replaced with "." to cast correctly
        for string in betragsArrString {
            betragsArrString[count] = string.replacingOccurrences(of: ",", with: ".")
            betragsArrDouble[count] = Double.init(betragsArrString[count])!
            
            
            // fixing the NaN bug
            
            if count != 4 {
            steuerBetragArr[count] = (betragsArrDouble[count] / steuersatzDiv[count]) * steuersatzArr[count]
            steuerBetragArr[count] = Double(round(100 * steuerBetragArr[count])/100)
            }
            count = count + 1
        }
        count = 0
        for betrag in betragsArrDouble{
            print("\(count): \(steuerBetragArr[count])")
            
            count = count + 1
            gesamtBrutto = gesamtBrutto + betrag
        }
        
        
        var steuerZeileArray = [Steuerzeile]()
        for count in  0 ..< steuersatzArr.count{
            if(steuerBetragArr[count] != 0.0){
//                let prozent = Int.init(steuersatzArr[count])
//                let prozentbetrag = steuerBetragArr[count]
//                let netto = betragsArrDouble[count] - steuerBetragArr[count]
//                let brutto = betragsArrDouble[count]
                
                
                
            var steuerzeile = Steuerzeile.init(prozent: Int.init(steuersatzArr[count]), prozentbetrag: steuerBetragArr[count], netto: betragsArrDouble[count] - steuerBetragArr[count], brutto: betragsArrDouble[count])
            steuerZeileArray.append(steuerzeile)
            print(steuerzeile)
                
            }
            
        }
        
        gesamtNetto = gesamtBrutto - (steuerBetragArr[0] + steuerBetragArr[1] + steuerBetragArr[2] + steuerBetragArr[3])
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d.M.yyyy"
        let date = dateFormatter.date(from: fertigDatum)
        var formattedDatum = fertigDatum
        
        if let date = date {
            formattedDatum = dateFormatter.string(from: date)
        }
        
        print("Datum: \(fertigDatum)")
        print(steuersatzArr)
        let billDataToReturn = BillData2.init(steuerzeilen: steuerZeileArray, gesamtBrutto: gesamtBrutto, datum: formattedDatum, rechnungsersteller: "Bitte Rechnungsersteller eingeben.", kontierung: "Kontierung auswählen.", bezahlung: "Bezahlart auswählen.")

 
        
        return billDataToReturn
        
    }
    
}
