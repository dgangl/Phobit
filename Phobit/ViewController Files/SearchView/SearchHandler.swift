//
//  SuchenHandler.swift
//  Phobit
//
//  Created by Paul Wiesinger on 11.01.18.
//  Copyright © 2018 Paul Wiesinger. All rights reserved.
//

import Foundation

//extension SuchenTableViewController {
//    // MARK: HANDLERS
//    // return true if the array they found has members, false when they found nothing
//    
//    
//    // keyzeichen
//    func keyzeichenHandler(zeichen: String, zahl: String) -> Bool {
//        let array = searchobject!.getArray()
//        let fo = FilterObject()
//        
//        
//        switch zeichen {
//        case ">":
//            for item in array {
//                print("kedasjflkajdlksf")
//                print(item.bruttoBetrag)
//            }
//        case "=":
//            break
//        case "<":
//            break
//        default:
//            print("Fehler: keyzeichen Handler")
//            return false
//        }
//        return false
//    }
//    
//    
//    // date
//    func dateHandler(date1: String, date2: String?) -> Bool {
//        let array = searchobject!.getArray()
//        let fo = FilterObject()
//        
//        let valOne = getDateValue(date: date1)
//        
//        
//        // zeitraum wird gesucht
//        if let date2 = date2 {
//            let valTwo = getDateValue(date: date2)
//            
//            for item in array {
//                if item.getDateValue() >= valOne && item.getDateValue() <= valTwo {
//                    fo.add(model: item)
//                }
//            }
//            
//            if fo.hasMembers() {
//                print(fo.array)
//                
//                filteredSearchObject = fo
//                return true
//            } else {
//                return false
//            }
//        }
//        
//        
//        // only specific date search
//        for item in array {
//            if item.getDateValue() == valOne {
//                fo.add(model: item)
//            }
//        }
//        
//        if fo.hasMembers() {
//            print(fo.array)
//            
//            filteredSearchObject = fo
//            return true
//        } else {
//            return false
//        }
//        
//    }
//    // jahr
//    
//    
//    
//    // monat
//    
//    // text or nothing
//    func textHandler(text: String) -> Bool {
//
//        let array = searchobject!.getArray()
//        let fo = FilterObject()
//        
//        for item in array {
//            
//            // only if it contains a letter... not good!
//            // TODO: write own compare Method.
//            if item.firma.lowercased().contains(text.lowercased()) {
//                fo.add(model: item)
//            }
//        }
//        
//        
//        if fo.hasMembers() {
//            print(fo.array)
//            
//            filteredSearchObject = fo
//            return true
//        } else {
//            return false
//        }
//    }
//}
//
