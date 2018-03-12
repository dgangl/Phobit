//
//  ImageDataStorer.swift
//  Phobit
//
//  Created by Julian Kronlachner on 24.02.18.
//  Copyright © 2018 Paul Wiesinger. All rights reserved.
//

import Foundation
import UIKit


class ImageData{
    
    
    public func writeImageTo(name : String, imageToWrite: UIImage){
        
        let imageData = UIImagePNGRepresentation(imageToWrite)!
        let documentDirectory = getDocumentsDirectory().appendingPathComponent(name)
        do{
            try imageData.write(to: documentDirectory)
        }catch{print("Error while writing Image to Document Directory \n Complete message: \n \(error)")}
    }
    
    public func getImage(name : String) -> UIImage? {
        let documentDirectory = getDocumentsDirectory().appendingPathComponent(name)
        if let newImage = UIImage(contentsOfFile: documentDirectory.path) {
            return newImage
        } else {
            return nil
        }
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
   
}

