//
//  Regonizer.swift
//  Phobit
//
//  Created by Julian Kronlachner on 04.01.18.
//  Copyright © 2018 Paul Wiesinger. All rights reserved.
//

import Foundation

class Regonzier{
    
    
    var array = [BillData]()
    
    //Just for testing usage!
    func inputFromFile(filename : String) -> [BillData]{
        
        if let longDataString = Bundle.main.path(forResource: filename, ofType: "csv"){
            do{
                var string = try String.init(contentsOfFile: longDataString)
                string = string.replacingOccurrences(of: "\n", with: "")
                var cuttedString = string.components(separatedBy: "\\")
                print(cuttedString.count - 1)
                cuttedString.remove(at: cuttedString.count-1)
                for strings in cuttedString{
                    let regonize = strings.components(separatedBy: ";")
                    array.append(regonizer(input: regonize))
                }
            }catch{
                
            }
            
            
            
        }
        return array
    }
    
    //The real regonizer
    func regonizer(input : [String]) -> BillData{
            var bill = BillData(brutto: Double.init(input[9])!, netto: Double.init(input[3])!, steuer20: Double.init(input[8])!, steuer19: Double.init(input[7])!, steuer13: Double.init(input[6])!, steuer10: Double.init(input[5])!, steuer0: Double.init(input[4])!, konto: Int.init(input[2])!, name: input[0], datum: input[1], bezahlung: input[10])
            return bill
    }
}
