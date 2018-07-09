//
//  DataMasterSearch.swift
//  Phobit
//
//  Created by 73 on 25.02.18.
//  Copyright © 2018 73. All rights reserved.
//

import Foundation


extension DataMaster {
    // billdata..
    // searched
    func search(text: String) {
        
        searchedbilldata = [BillData2]()
        
        print("Eingabe: " + text);
        print("Now checking Price")
        Sonderzeichen(input: text)
        print("Now checking DATE");
        checkDate(text: text)
        print("Now checking MONTH")
        checkMonth(text: text);
        print("Now checking STRING")
        checkElse(texti: text)
        
    }
    
    
    //
    //  DatumConvert.swift
    //  ConverterSearch
    //
    //  Created by 73 on 03.03.18.
    //  Copyright © 2018 73. All rights reserved.
    //
    
    func zeitraumsuche(text: String) -> Bool {
        
        if(text.contains("-") != true){
            return false;
        }
        var array = text.split(separator: "-")
        
        let firstDate = stringToDate(text: array[0].description);
        let secondDate = stringToDate(text: array[1].description);
        if(firstDate != nil && secondDate != nil){
            zeiteingabe(firstDate: firstDate!, secondDate: secondDate!);
        }
        
        
        return true;
        
    }
    
    func Sonderzeichen(input: String) -> Bool{
        if(input != ""){
            var result: Double = -1
            let setcomma = input.replacingOccurrences(of: ",", with: ".", options: NSString.CompareOptions.literal, range: nil)
            let deleteLeerzeichen = input.replacingOccurrences(of: " ", with: "", options: NSString.CompareOptions.literal, range: nil)
            if(deleteLeerzeichen.count < 3){
                return false;
            }
            var splitary = Array(deleteLeerzeichen)
            
            switch splitary[0] {
            case "<":
                var elements: String = "";
                for (index,element) in splitary.enumerated(){
                    if Double(String(splitary[index])) != nil {
                        elements.append(element)
                    }
                }
                
                if Double(elements) != nil{
                    result = Double(elements)!
                        for userVar in billdata{
                            if(userVar.gesamtBrutto <= result && result != -1){
                                searchedbilldata?.append(userVar)
                            }
                        }
                    
                }
            case ">":
                var elements: String = "";
                for (index,element) in splitary.enumerated(){
                    if Double(String(splitary[index])) != nil {
                        elements.append(element)
                    }
                }
                if Double(elements) != nil{
                    result = Double(elements)!
                        for userVar in billdata{
                            if(userVar.gesamtBrutto >= result && result != -1){
                                searchedbilldata?.append(userVar)
                            }
                        }
                    
                }
            case "=":
                var elements: String = "";
                for (index,element) in splitary.enumerated(){
                    if Double(String(splitary[index])) != nil {
                        elements.append(element)
                    }
                }
                if Double(elements) != nil{
                    result = Double(elements)!
                        for userVar in billdata{
                            if(userVar.gesamtBrutto == result && result != -1){
                                searchedbilldata?.append(userVar)
                            }
                        }
                    }
                
            default:
                switch splitary[splitary.count-1]{
                case "€":
//                    if(splitary.contains("-")){
//                        var zahl1: String = ""
//                        var zahl2: String = ""
//                        var stringsplitary: String = ""
//                        for s in splitary{
//                            stringsplitary.append(s)
//                        }
//
//
//                        let deleteEuro = stringsplitary.replacingOccurrences(of: "€", with: "", options: NSString.CompareOptions.literal, range: nil)
//                        zahl1 = String(deleteEuro.split(separator: "-")[0])
//                        zahl2 = String(deleteEuro.split(separator: "-")[1])
//
//
//                        var a: Double = Double(zahl1)!
//                        print(a)
//                        if Double(zahl1) != nil && Double(zahl2) != nil{
//                            if Double(zahl1)! <= Double(zahl2)!{
//                                for userVar in billdata{
//                                    if userVar.gesamtBrutto >= Double(zahl1)! && userVar.gesamtBrutto <= Double(zahl2)!{
//                                        searchedbilldata?.append(userVar)
//                                    }
//                                }
//
//                            }else{
//                                for userVar in billdata{
//                                    if userVar.gesamtBrutto <= Double(zahl1)! && userVar.gesamtBrutto >= Double(zahl2)!{
//                                        searchedbilldata?.append(userVar)
//                                    }
//                                }
//                            }
//                        }
//                    }else{
                        var elements: String = "";
                        for (index,element) in splitary.enumerated(){
                            if Double(String(splitary[index])) != nil {
                                elements.append(element)
                            }                else if splitary[index] == "."{
                                elements.append(element)
                            }
                        }
                        if Double(elements) != nil{
                            result = Double(elements)!
                            for userVar in billdata{
                                if(userVar.gesamtBrutto >= (result*0.9) && userVar.gesamtBrutto <= (result*1.1) && result != -1){
                                    searchedbilldata?.append(userVar)
                                }
                                
                            }
                        }
//                    }
                default:
                    if(splitary.contains("-") && splitary.last != "-"){
                        var zahl1: Double
                        var zahl2: Double
                        var stringsplitary: String = ""
                        for s in splitary{
                            stringsplitary.append(s)
                        }
                        
                        
                        let deleteEuro = stringsplitary.replacingOccurrences(of: "€", with: "", options: NSString.CompareOptions.literal, range: nil)
                        zahl1 = -1
                        zahl2 = -1
                        if(deleteEuro.split(separator: "-").count == 2){
                        zahl1 = Double(String(deleteEuro.split(separator: "-")[0]))!
                        zahl2 = Double(String(deleteEuro.split(separator: "-")[1]))!
                        }
                        
                        //var a: Double = Double(zahl1)!
                       // print(a)
                        if zahl1 != nil && zahl2 != nil{
                            if zahl1 <= zahl2{
                                for userVar in billdata{
                                    if userVar.gesamtBrutto >= zahl1 && userVar.gesamtBrutto <= zahl2{
                                        searchedbilldata?.append(userVar)
                                    }
                                }
                                
                            }else{
                                for userVar in billdata{
                                    if userVar.gesamtBrutto <= zahl1 && userVar.gesamtBrutto >= zahl2{
                                        searchedbilldata?.append(userVar)
                                    }
                                }
                            }
                        }
                    }else{
                    return false;
                    }
                }
            }
        }
        return true
    }
    
    func zeiteingabe(firstDate: Date, secondDate: Date) {
        
        for choosenVar in billdata {
            let variable = choosenVar.getDate();
            
            if(firstDate.compare(variable).rawValue == -1){

                if(secondDate.compare(variable).rawValue == 1){
                    searchedbilldata?.append(choosenVar);
                    
                }
                
            }
        }
        if(searchedbilldata == nil){
            return;
        }
        print(searchedbilldata ?? "EMPTY")
        
    }
    
    func checkDate(text: String) -> Bool {
        let deletLerzeichen = text.replacingOccurrences(of: " ", with: "");
        var splited = Array(deletLerzeichen);
        
        
        while(true){
            if(splited.count <= 0){
                return false;
            }
            
            var test:String = "";
            test.append(splited.first!);
            let first = test;
            
            
            if let number = Double(first){
                break;
            } else {
                splited.removeFirst();
            }
        }
        var fullTextString: String = "";
        
        for stelle in splited {
            fullTextString.append(stelle);
        }
        
       
        let date = convertToDate(dateString: fullTextString);
        print(date ?? "") //
        if(date == nil){
            return false;
        }
        durchsuche(deinDatum: date!, datumArray: billdata)
        
        return true;
        
    }
    
    func stringToDate(text: String) -> Date? {
        let deletLerzeichen = text.replacingOccurrences(of: " ", with: "");
        var splited = Array(deletLerzeichen);
        
        
        while(true){
            if(splited.count <= 0){
                return nil;
            }
            
            var test:String = "";
            test.append(splited.first!);
            let first = test;
            
            
            if let number = Double(first){
                break;
            } else {
                splited.removeFirst();
            }
        }
        var fullTextString: String = "";
        
        for stelle in splited {
            fullTextString.append(stelle);
        }
        
        
        let date = convertToDate(dateString: fullTextString);
        print(date ?? "") //
        return date;
    }
    
    func convertToDate(dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d.M.yy"
        var serverDate: Date? = dateFormatter.date(from: dateString) // according to date format your date string
        if(serverDate == nil){
            let date = Date()
            let calendar = Calendar.current
            
            let year = calendar.component(.year, from: date)
            
            let nextDate: String = dateString.appending("." + year.description);
            
             serverDate = dateFormatter.date(from: nextDate) // according to date format your date string
            
        }
        return serverDate
    }
    
    
    func checkMonth(text: String) -> Bool {
        let deletLerzeichen = text.replacingOccurrences(of: " ", with: "");
        let month = Monate.init(searchText: deletLerzeichen);
        if(month.getMonth() == nil){
            return false;
        }
        var finished:String = "00.";
        let monates = month.getMonth()?.description;
        finished.append(monates!);
        
        var counter:Int = 2018;
        while foundResults(jahr: counter, texting: finished) <= 1 {
            counter = counter - 1;
            
            if(counter <= 2000){
                
                return false;
                
            }
        }
        
        return true;
    }
    
    func foundResults(jahr: Int, texting: String) ->Int {
        
        var text = texting;
        let dateFormatter = DateFormatter()
        text.append(".");
        text.append(jahr.description);
        dateFormatter.dateFormat = text;
        guard let date = dateFormatter.date(from: text) else {
            return 0;
        }
        durchsucheMonat(deinDatum: date, array: billdata);
        
        
        if(searchedbilldata == nil){
            return 0;
        }
        return (searchedbilldata?.count)!;
        
        
    }
    
    func durchsuche(deinDatum: Date, datumArray: [BillData2]) {
        
        
        for choosenDate in datumArray {
            let variable = choosenDate.getDate();
            if(deinDatum.compare(variable).rawValue == 0){
                searchedbilldata?.append(choosenDate);
            }
        }
        
        //USE finishedArray
        
        
        print(searchedbilldata ?? "EMPTY");
    }
    
    func durchsucheMonat(deinDatum: Date, array: [BillData2]) {
        
        
        for choosenVar in array {
            let variable = choosenVar.getDate();
            
            if(deinDatum.compare(variable).rawValue == -1){
                
                var dateComponent = DateComponents();
                dateComponent.day = 31;
                
                let futureDate = Calendar.current.date(byAdding: dateComponent, to: deinDatum);
                
                if(deinDatum.compare(variable).rawValue == 1){
                    
                    //searchedbilldata.append(choosenVar);
                    searchedbilldata?.append(choosenVar);
                    
                }
                
            }
        }
        if(searchedbilldata == nil){
            return;
        }
        print(searchedbilldata ?? "EMPTY")
    }
    func checkElse(texti: String) -> Bool {
        let text = texti.lowercased()
        if(text.count <= 0){
            return false;
        }
        for item in billdata {
            var name = item.rechnungsersteller;
            name = name.lowercased()
            if(name.contains(text)){
                searchedbilldata?.append(item);
            }
        }
        
        print(searchedbilldata ?? "NOTHING FOUND");
        return true;
    }
}

