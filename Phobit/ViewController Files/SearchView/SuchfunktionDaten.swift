//
//  SuchfunktionDaten.swift
//  Phobit
//
//  Created by Paul Wiesinger on 28.12.17.
//  Copyright © 2017 Paul Wiesinger. All rights reserved.
//

import Foundation


struct SuchfunktionDaten {
    var rechnungsersteller: String
    var bruttobetrag: Double
    var nettobetrag: Double
    var belegdatum: String
    
    
    // Optional-werte für Steuerbeträge
    var zwanzigProzent: Double?
    var neunzehnProzent: Double?
    var dreizehnProzent: Double?
    var zehnProzent: Double?
    var nullProzent: Double?
    
    init(rechnungsersteller: String, bruttobetrag: Double, nettobetrag: Double, belegdatum: String, zwanzigProzent: Double?, neunzehnProzent: Double?, dreizehnProzent: Double?, zehnProzent: Double?, nullProzent: Double?) {
        self.rechnungsersteller = rechnungsersteller
        self.bruttobetrag = bruttobetrag
        self.belegdatum = belegdatum
        self.nettobetrag = nettobetrag
        self.zwanzigProzent = zwanzigProzent
        self.neunzehnProzent = neunzehnProzent
        self.dreizehnProzent = dreizehnProzent
        self.zehnProzent = zehnProzent
        self.nullProzent = nullProzent
    }
}
