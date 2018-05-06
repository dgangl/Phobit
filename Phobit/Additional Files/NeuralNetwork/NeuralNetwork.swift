//
//  NeuralNetwork.swift
//  Phobit
//
//  Created by Julian Kronlachner on 26.04.18.
//  Copyright © 2018 LonoS. All rights reserved.
//

import Foundation


class Tagger{
    let tagger = NSLinguisticTagger(tagSchemes:[.tokenType, .language, .lexicalClass, .nameType, .lemma], options: 0)
    let options: NSLinguisticTagger.Options = [.omitPunctuation, .omitWhitespace, .joinNames]
    
    var lines : [String] = []
    
    
    
    func recognizeOCR_Result(für text: String) -> String? {
        let words = namedEntityRecognition(for: text)
        for name in words{
            if(name.value == .organizationName){
                print("Rechnungsersteller könnte: \(name.key) sein")
                return name.key
            }
        }
        return nil
        
        
        
    }
    
    
   
    private func namedEntityRecognition(for text: String) -> [String : NSLinguisticTag ]{
        var words : [String : NSLinguisticTag] = [:]

        tagger.string = text
        let range = NSRange(location: 0, length: text.utf16.count)
        tagger.enumerateTags(in: range, unit: .word, scheme: .nameType, options: options) { tag, tokenRange, stop in
            if let tag = tag{
                let name = (text as NSString).substring(with: tokenRange)
                print("\(name): \(tag.rawValue)")
                words[name] = tag
            }
        }
        return words
    }
    
    
    
   
}


