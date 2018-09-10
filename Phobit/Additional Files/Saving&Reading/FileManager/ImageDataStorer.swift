//
//  ImageDataStorer.swift
//  Phobit
//
//  Created by 73 on 24.02.18.
//  Copyright © 2018 73. All rights reserved.
//

import Foundation
import UIKit


class ImageData{
    
    
    public func writeImageTo(name : String, imageToWrite: UIImage){
        
        let imageData = UIImagePNGRepresentation(imageToWrite)!
        
//        let imageData = UIImageJPEGRepresentation(imageToWrite, 1.0)!
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
    
    
    
    // NOT TESTED
    func DeleteImage(uuid: String) {
        let url = getDocumentsDirectory().appendingPathComponent(uuid)
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            print(error)
        }
    }
}

