//
//  NeuralNetDataGetter.swift
//  Phobit
//
//  Created by Julian Kronlachner on 05.07.18.
//  Copyright © 2018 LonoS. All rights reserved.
//

import UIKit

class NeuralNetDataGetter{
    var db : Database
    
    var allBills: [String : [String : Any]]?
    
    init() {
        db = Database.init()
        getData() 
    }
    
    
    private func getData(){
        db.getDicOfData(completion: {dictionary in
            self.allBills = dictionary
            print("Done")
        })
        
    }
}
    
    
    
    
    
    
    
    
    
    
    
    
    

