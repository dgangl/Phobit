//
//  VerwendungszweckTests.swift
//  Phobit_Tests
//
//  Created by Julian Kronlachner on 16.06.18.
//  Copyright © 2018 LonoS. All rights reserved.
//

import XCTest

class VerwendungszweckTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAddVerwendungszweck(){
        let controller = ChooseKontierungViewController.init(style: .plain)
        controller.createNewVerwendungszweckEntry(verwendungszweck: "Gartenwerkzeug")
        var konten : [String] = [""];
        if let path = Bundle.main.path(forResource: "PhobitKontenplan", ofType: "csv") {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                konten = data.components(separatedBy: .newlines)
            } catch {
                print(error)
            }
            konten.removeLast()
        }
        
        for s in konten{
            XCTAssert(s.elementsEqual("Gartenwerkzeug"), "TEST :: Verwendungszweck schreiben .. OK")
        }
        
    }

}
