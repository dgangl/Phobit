//
//  DataMaster.swift
//  Phobit
//
//  Created by 73 on 19.02.18.
//  Copyright © 2018 73. All rights reserved.
//

import Foundation

class DataMaster {
    
    var dates: [String]
    var billdata: [BillData2]
    var anzahlProDatum: [String:Int]
    
    // is filled when we searched for something
    var searchedbilldata: [BillData2]?
    
    
    // the init to use.
    init(billdata: [BillData2]) {
        self.billdata = billdata
        
        for bill in billdata {
            print(bill.rechnungsersteller)
        }
        
        // just before we calculated it.
        self.dates = [String]()
        self.anzahlProDatum = [String:Int]()
        

        
        calculateDates()
    }
    
    
    
    init() {
        self.billdata = [BillData2]()
        self.dates = [String]()
        self.anzahlProDatum = [String:Int]()
        print("initalized emtpy dataMaster.")
    }
    
    ///////////////////////////////
    // Data Source for Table View
        // for loading the data into search view
    func getCellData(forIndexPath indexPath: IndexPath) -> (String, String) {
        let index = aufsummieren(indexPath: indexPath)
        let firma = billdata[index].rechnungsersteller
        let betrag = CFormat.correctGeldbetrag(zahl: String(billdata[index].gesamtBrutto))
    
        return (firma, betrag)
    }
    
    func getNumberOfSections() -> Int {
        return dates.count
    }
    
    func getNumberOfRowsInSections(section: Int) -> Int {
        return anzahlProDatum[dates[section]] ?? 0
    }
    
    
        // for pressing the data.
    
    func getBillDataForCell(indexPath:IndexPath) -> BillData2 {
        let index = aufsummieren(indexPath: indexPath)
        return billdata[index]
    }
    //
    //////////////////////////////
    
    
    // shows what number the cell is in the datamaster system.
    private func aufsummieren(indexPath: IndexPath) -> Int {
        var anzahl = 0
        for number in 0..<indexPath.section {
            let datum = dates[number]
            anzahl = anzahl + anzahlProDatum[datum]!
        }
        anzahl += indexPath.row
        
        return anzahl
    }
    
    
    
    private func calculateDates() {
        
        // sorting the array, to ensure that anzahlProDatum is in the right order.
        billdata.sort { (s1, s2) -> Bool in
            return s1.getDate() > s2.getDate()
        }
        
        // getting the dates of all billdatas
        _ = billdata.map({ (data) -> Void in
            if dates.contains(data.datum) == false {
                dates.append(data.datum)
                
                anzahlProDatum[data.datum] = 1
                
            } else {
                anzahlProDatum[data.datum]! += 1
            }
        })
        
        
        // sort the dates array...
        dates.sort { (s1, s2) -> Bool in
            return CFormat.getDateFromString(datum: s1) > CFormat.getDateFromString(datum: s2)
        }

        
        print("Dates in Table View: \(dates)")
    }
}
