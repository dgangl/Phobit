//
//  Phobit_Tests.swift
//  Phobit_Tests
//
//  Created by 73 on 13.06.18.
//  Copyright © 2018 73. All rights reserved.
//

import XCTest



class Phobit_Tests_BillData: XCTestCase {
    var bill : BillData2? = nil;
    
    override func setUp() {
        super.setUp()
        bill = BillData2(datum: "21.08.2002", rechnungsersteller: "Hofer", kontierung: "Privat", bezahlung: "Bar")
        bill?.steuerzeilen = [Steuerzeile.init(prozent: 10, prozentbetrag: 1.0, netto: 9.0, brutto: 10.0)]
        
    }
    
    override func tearDown() {
        super.tearDown()
        
        
    }
    
    func testKontierung(){
        XCTAssert(bill?.kontierung == "Privat")
        
    }
    
    func testSteuerzeilen(){
        XCTAssert(bill?.getNumberOfSteuerzeilen() == 1)
    }
    
    
    
    
    
    
}
