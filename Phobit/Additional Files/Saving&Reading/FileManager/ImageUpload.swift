//
//  ImageUpload.swift
//  Phobit
//
//  Created by Julian Kronlachner on 03.03.18.
//  Copyright © 2018 LonoS. All rights reserved.
//

import Foundation
import Alamofire
import TesseractOCR

class ImageUpload{
   
    
    
    static func requestWith(endUrl: String, image: UIImage){
        let image = #imageLiteral(resourceName: "3391_001")
        let url = endUrl
        let imageData = UIImagePNGRepresentation(image.g8_blackAndWhite())
        let headers = [
            "ocrEngine" : "0",
//            "file" : "file",
//            "submit" : "Upload",
//            "__RequestVerificationToken" : "CfDJ8HVc80c9-RdDmo70-kzWpNTgdaAy4_3w_nsNPNunbLBdBg3YcgwxgSMXhcoCsuufdPpNeR1Dk1kf5ymS6m_P1Gk7jOzWky6JA7kxLJ83F6xFWkFmCmLTe3pgrA_t4HZkBnGKIsh6PyqhP1ux-I7VF34"
        ]
       
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            if let data = imageData{
                multipartFormData.append(data, withName: "file", fileName: "file.png", mimeType: "image/png")
            }
            
        }, usingThreshold: UInt64.init(), to: url, method: .post, headers: headers) { (result) in
            
            
            
            
            
            
            switch result{
                
                
                
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    print("Succesfully uploaded")
                    if let err = response.error{
                        print("JSON FAILED")
                    }
                  
                }
                upload.responseString{ response in
                    print("STRING RESPONSE: \(response)")
                    
                }
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
            }
        }

    }
}


