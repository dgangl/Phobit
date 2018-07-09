//
//  RandomErrorMessage.swift
//  Phobit
//
//  Created by Paul Wiesinger on 05.07.18.
//  Copyright © 2018 LonoS. All rights reserved.
//

import Foundation

class RandomLoadingMessages {
    
    // if we can not load a random string (for some reason)
    var message = "Bitte warten."
    
    init() {
        self.load()
    }
    
    
    fileprivate func load() {
        if let path = Bundle.main.path(forResource: "LoadingMessages", ofType: "plist") {
            if let dict = NSDictionary.init(contentsOfFile: path) as? Dictionary<String, AnyObject> {
                let array = dict["messages"] as! [String]
                
                self.message = array[getRandomNumber(range: array.count)]
            }
        }
    }
    
    
    fileprivate func getRandomNumber(range: Int) -> Int {
        return Int(arc4random_uniform(UInt32(range)))
    }
}
