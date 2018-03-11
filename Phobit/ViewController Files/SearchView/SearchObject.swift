//
//  SearchObject.swift
//  Phobit
//
//  Created by Paul Wiesinger on 06.01.18.
//  Copyright © 2018 Paul Wiesinger. All rights reserved.
//

import Foundation


class SearchObject {
    var array = [SearchDataModel]()
    var dates = [String]()
    
    
    // used to return the exact cell for the specific section
    var counter = 0
    // is used to get the number of rows in section
    var datesDict = [String : Int]()
    
    
    let regonizer = Regonzier()
    
    
    // get the dict from the viewcontroller
    init(dict: [Int : [String]]) {
        for index in 0..<dict.count {
            let arr = dict[index]
            let bill = regonizer.regonizer(input: arr!)
            
            let model = SearchDataModel(firma: bill.getRechnungsersteller(), bruttoBetrag: "\(bill.getBrutto())" , datum: bill.getDatum(), dictID: index, billData: bill)
            array.append(model)
            
            
            // check if date is available
            if dates.contains(bill.getDatum()) == false {
                dates.append(bill.getDatum())
                datesDict[bill.getDatum()] = 1
            } else if dates.contains(bill.getDatum()) == true {
                
                datesDict[bill.getDatum()]! += 1
            }
        }
        
        sort()
    }
    
    
    
    func sort() {
        // sort the array by dateValue here
        
        array.sort(by: {$0.getDateValue() > $1.getDateValue()})
        dates.sort(by: {getDateValue(date: $0) > getDateValue(date: $1)})
        print(dates)
        print(array)
    }
    
    
    func getNumberOfRowsIn(section: Int) -> Int {
        return datesDict[dates[section]]!
    }
    
    // to return the dates for loading
    func getDates() -> [String]? {
        // return Dates here
        return dates
    }
    
    
    func getArrLenght() -> Int {
        return array.count
    }
    
    // to return the whole array for loading
//    func getNextObject() -> SearchDataModel {
//        let rg = array[counter]
//
//        counter += 1
//
//        if counter == (array.count) {
//            counter = 0
//        }
//
//        return rg
//    }
    
    func getObject(byIndexPath index: IndexPath) -> (SearchDataModel, Int) {
        var objectIndex = 0
        
        for number in 0..<index.section {
            objectIndex += datesDict[dates[number]]!
        }
        objectIndex += index.row
        
        let sdm = array[objectIndex]
        
        return (sdm, objectIndex)
    }
    
    
    
    
    func getObject(byCellID: Int) -> SearchDataModel {
        return array[byCellID]
    }
    
    // returns the dataValue to compare it.
    func getDateValue(date: String) -> Int {
        let splitedArr = date.components(separatedBy: ".")
        
        let tag = Int(splitedArr[0])!
        let monat = Int(splitedArr[1])! * 31
        let jahr = Int(splitedArr[2])! * 1000
        
        return (tag + monat + jahr)
    }
    
    func getArray() -> [SearchDataModel] {
        return array
    }
}
