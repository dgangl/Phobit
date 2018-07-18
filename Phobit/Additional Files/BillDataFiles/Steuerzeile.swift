//
//  Steuerzeile.swift
//  Phobit
//
//  Created by 73 on 16.02.18.
//  Copyright © 2018 73. All rights reserved.
//

import Foundation

class Steuerzeile: NSObject, NSCoding{
    
    
    private var prozent : Int
    private var prozentbetrag : Double
    private var brutto : Double
    private var netto : Double
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(prozent, forKey: "prozent")
        aCoder.encode(prozentbetrag, forKey: "prozentbetrag")
        aCoder.encode(brutto, forKey: "brutto")
        aCoder.encode(netto, forKey: "netto")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.prozent = aDecoder.decodeInteger(forKey: "prozent")
        self.prozentbetrag = aDecoder.decodeDouble(forKey: "prozentbetrag")
        self.brutto = aDecoder.decodeDouble(forKey: "brutto")
        self.netto = aDecoder.decodeDouble(forKey: "netto")
    }
    
    init(prozent: Int, prozentbetrag: Double, netto : Double, brutto : Double) {
        self.prozentbetrag = prozentbetrag
        self.prozent = prozent
        self.netto = netto
        self.brutto = brutto
    }
}




extension Steuerzeile{
    
    public func getProzent() -> Int{
        return prozent
    }
    public func getProzentbetrag() -> Double{
        return prozentbetrag
    }
    public func getBrutto() -> Double{
        return brutto
    }
    public func getNetto() -> Double{
        return netto
    }
    
    public func setProzent(prozent : Int){
        self.prozent = prozent
    }
    public func setProzentbetrag(prozentbetrag : Double){
        self.prozentbetrag = prozentbetrag
    }
    public func setBrutto(brutto : Double){
        self.brutto = brutto
    }
    public func setNetto(netto : Double){
        self.netto = netto
    }
    
}


