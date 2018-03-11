//
//  BillData.swift
//  Phobit
//
//  Created by Julian Kronlachner on 04.01.18.
//  Copyright © 2018 LonoS. All rights reserved.
//

import Foundation
import UIKit


// items for table view array
//struct Item {
//    var changes = false
//    
//    var value: String {
//        // for checking later
//        didSet{
//            changes = true
//        }
//    }
//
//    var description: String?
//
//
//
//    // initializer
//    init(value: String, description: String?) {
//        self.value = value
//        self.description = description
//    }
//}



class BillData: NSObject, NSCoding{
    
    
    
  
    
    private var brutto : Double = 0.0
    private var netto : Double = 0.0
    
    private var steuer20 : Double = 0.0
    private var steuer10 : Double = 0.0
    private var steuer13 : Double = 0.0
    private var steuer19 : Double = 0.0
    private var steuer0 : Double = 0.0
    
    
    private var konto : Int = 0
    private var name : String = ""
    private var datum : String = ""
    private var bezahlung : String = ""
    
    
    //MARK: Normal Initializer
    init(brutto: Double, netto : Double, steuer20 : Double, steuer19 : Double, steuer13 : Double, steuer10: Double, steuer0 : Double, konto : Int, name : String, datum : String, bezahlung : String) {
        self.brutto = brutto
        self.netto = netto
        self.steuer20 = steuer20
        self.steuer19 = steuer19
        self.steuer13 = steuer13
        self.steuer0 = steuer0
        self.steuer10 = steuer10
        self.konto = konto
        self.name = name
        self.datum = datum
        self.bezahlung = bezahlung
        
    }
    
    init(_ : Double){
        
    }
    
    //ENCODER
    func encode(with aCoder: NSCoder) {
        aCoder.encode(brutto, forKey: "brutto")
        aCoder.encode(netto, forKey: "netto")
        aCoder.encode(steuer20, forKey: "steuer20")
        aCoder.encode(steuer19, forKey: "steuer19")
        aCoder.encode(steuer0, forKey: "steuer0")
        aCoder.encode(steuer10, forKey: "steuer10")
        aCoder.encode(steuer13, forKey: "steuer13")
        aCoder.encode(konto, forKey: "konto")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(datum, forKey: "datum")
        aCoder.encode(bezahlung, forKey: "bezahlung")
        
    }
    
    //DECODER
    required init?(coder aDecoder: NSCoder) {
        self.brutto = aDecoder.decodeDouble(forKey: "brutto")
        self.netto = aDecoder.decodeDouble(forKey: "netto")
        self.steuer20 = aDecoder.decodeDouble(forKey: "steuer20")
        self.steuer19 = aDecoder.decodeDouble(forKey: "steuer19")
        self.steuer13 = aDecoder.decodeDouble(forKey: "steuer13")
        self.steuer0 = aDecoder.decodeDouble(forKey: "steuer0")
        self.steuer10 = aDecoder.decodeDouble(forKey: "steuer10")
        self.konto = Int(aDecoder.decodeInt64(forKey: "konto"))
        self.name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        self.datum = aDecoder.decodeObject(forKey: "datum") as? String ?? ""
        self.bezahlung = aDecoder.decodeObject(forKey: "bezahlung") as? String ?? ""
    }
    
    
}
//All other Methods
extension BillData{
    
   
    func pruefeBillData() -> Bool{
        var returnType : Bool = true
        
        if(name == "Bitte eingeben!"){
            returnType = false
        }
        if((steuer10 + steuer13 + steuer19 + steuer20 + netto) != brutto){
            returnType = false
        }
        if(name == "" || datum == "" || bezahlung == ""){
            returnType = false
        }
        return returnType
    }
    
    func pruefeRechnerischeRichtigkeit() -> Bool{
        let gesamtSteuer = steuer10 + steuer20 + steuer13 + steuer19 + steuer0
        if(gesamtSteuer + netto != brutto){
            return false
        }
        return true
        
        
    }
    
  
}

//Getter
extension BillData{
    
    
    func getTableViewArray() -> [Item] {
        
        var array = [Item]()
        array.append(Item(value: getRechnungsersteller(), description: nil))
        array.append(Item(value: getDatum(), description: "Datum"))
        array.append(Item(value: formatFromDoubleToString(number: getNetto()), description: "Nettobetrag"))
        array.append(Item(value: formatFromDoubleToString(number: getBrutto()), description: "Bruttobetrag"))
        
        
        
        // checking prozentsätze
        
        if steuer0 != 0 {
            array.append(Item(value: formatFromDoubleToString(number: getSteuer0()), description: "0% Steuer"))
        }
        
        if steuer10 != 0 {
            array.append(Item(value: formatFromDoubleToString(number: getSteuer10()), description: "10% Steuer"))
        }
        
        if steuer13 != 0 {
            array.append(Item(value: formatFromDoubleToString(number: getSteuer13()), description: "13% Steuer"))
        }
        
        if steuer19 != 0 {
            array.append(Item(value: formatFromDoubleToString(number: getSteuer19()), description: "19% Steuer"))
        }
        
        if steuer20 != 0 {
            array.append(Item(value: formatFromDoubleToString(number: getSteuer20()), description: "20% Steuer"))
        }
        
        array.append(Item(value: String(getKontierung()), description: nil))
        array.append(Item(value: getBezahlart(), description: nil))
        
        return array
        
    }
    func checkChanges(onArray items: [Item]) {
        
        var counter = 0
        for item in items  {
            if item.changes == true {
                switch counter {
                case 0:
                    setRechnungsersteller(name: item.value)
                case 1:
                    setDatum(datum: item.value)
                case 2:
                    setNetto(netto: convertStringNumberToDouble(number: item.value))
                case 3:
                    setBrutto(brutto: convertStringNumberToDouble(number: item.value))
                case (getAnzahlSteuersätze() + 4):
                    setKontierung(konto: Int(item.value)!)
                case (getAnzahlSteuersätze() + 5):
                    setBezahlart(bezahlung: item.value)
                default:
                    checkSteuer(item: item)
                }
                
            }
            
            counter += 1
        }
    }
    
    private func checkSteuer(item: Item) {
        if let descr = item.description {
            switch descr {
            case "0% Steuer":
                setSteuer0(steuer: convertStringNumberToDouble(number: item.value))
            case "10% Steuer":
                setSteuer10(steuer: convertStringNumberToDouble(number: item.value))
            case "13% Steuer":
                setSteuer13(steuer: convertStringNumberToDouble(number: item.value))
            case "19% Steuer":
                setSteuer19(steuer: convertStringNumberToDouble(number: item.value))
            case "20% Steuer":
                setSteuer20(steuer: convertStringNumberToDouble(number: item.value))
            default:
                print("found no match in checkSteuerl, witch value: \(descr)")
            }
        }
    }
    
    
    // TODO: format ist to double again...
    private func convertStringNumberToDouble(number: String) -> Double {
        let newNumber = number.replacingOccurrences(of: ",", with: ".")
        return Double(newNumber)!
    }
    
    func getAnzahlSteuersätze() -> Int {
        var counter = 0
        
        if steuer0 != 0 {
            counter += 1
        }
        
        if steuer10 != 0 {
            counter += 1
        }
        
        if steuer13 != 0 {
            counter += 1
        }
        
        if steuer19 != 0 {
            counter += 1
        }
        
        if steuer20 != 0 {
            counter += 1
        }
        
        
        return counter
    }
    
    
    private func formatFromDoubleToString(number: Double) -> String {
        return String.init(format: "%.2f", number).replacingOccurrences(of: ".", with: ",")
    }
    
    
    
    // is not used right now...
    private func getBelegteSteuersätze() -> [Bool] {
        var steuern = [false, false, false, false, false]
        
        if steuer0 != 0 {
            steuern[0] = true
        }
        
        if steuer10 != 0 {
            steuern[1] = true
        }
        
        if steuer13 != 0 {
            steuern[2] = true
        }
        
        if steuer19 != 0 {
            steuern[3] = true
        }
        
        if steuer20 != 0 {
            steuern[4] = true
        }
        
        return steuern
    }
}








//Getter
extension BillData{
    
    func getBrutto() -> Double{
        return brutto
    }
    
    func getNetto() -> Double{
        return netto
    }
    
    func getSteuer20() -> Double{
        return steuer20
    }
    
    func getSteuer10() -> Double{
        return steuer10
    }
    
    func getSteuer13() -> Double{
        return steuer13
    }
    
    func getSteuer19() -> Double{
        return steuer19
    }
    
    func getSteuer0() -> Double{
        return steuer0
    }
    
    func getKontierung() -> Int{
        return konto
    }
    
    func getRechnungsersteller() -> String{
        return name
    }
    
    func getDatum() -> String{
        return datum
    }
    
    func getBezahlart() -> String{
        return bezahlung
    }
    
}





//Setter
extension BillData{
    
    
    func setBrutto(brutto : Double){
        self.brutto = brutto
    }
    
    func setNetto(netto : Double){
        self.netto = netto
    }
    
    func setSteuer20(steuer : Double){
        self.steuer20 = steuer
    }
    
    func setSteuer10(steuer : Double){
        self.steuer10 = steuer
    }
    
    func setSteuer13(steuer : Double){
        self.steuer13 = steuer
    }
    
    func setSteuer19(steuer : Double){
        self.steuer19 = steuer
    }
    
    func setSteuer0(steuer : Double){
        self.steuer0 = steuer
    }
    
    func setKontierung(konto : Int){
        self.konto = konto
    }
    
    func setRechnungsersteller(name : String){
        self.name = name
    }
    
    func setDatum(datum : String){
        self.datum = datum
    }
    
    func setBezahlart(bezahlung : String){
        self.bezahlung = bezahlung
    }
    
    
    
    
    
}
