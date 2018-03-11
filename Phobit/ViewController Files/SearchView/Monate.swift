//
//  Monate.swift
//  Phobit
//
//  Created by Paul Wiesinger on 10.01.18.
//  Copyright © 2018 Paul Wiesinger. All rights reserved.
//

import Foundation

struct Monate {
    
    let searchText: String
    
    
    // searchText has to be absolutley free of " "
    init(searchText: String) {
        self.searchText = searchText.lowercased()
    }
    
    func getMonth() -> Int? {
        switch searchText {
        case "jan", "jan.", "january", "januar", "jänner", "jän":
            return 1
        case "feb", "feb.", "february", "februar", "feber":
            return 2
        case "mar", "mar.", "mär. ", "mär", "march", "märz":
            return 3
        case "apr ", "apr.", "april":
            return 4
        case "may", "mai":
            return 5
        case "jun", "jun.", "june", "juni":
            return 6
        case "jul", "jul.", "july", "juli":
            return 7
        case "aug", "aug.", "august":
            return 8
        case "sep", "sep.", "september":
            return 9
        case "oct", "oct.", "okt", "okt. ", "october", "oktober":
            return 10
        case "nov", "nov.", "november":
            return 11
        case "dez.", "dec.", "dez", "december", "dezember":
            return 12
        default:
            return nil
        }
    }
}
