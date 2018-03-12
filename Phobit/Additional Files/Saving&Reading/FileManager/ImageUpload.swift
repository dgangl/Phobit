//
//  ImageUpload.swift
//  Phobit
//
//  Created by Julian Kronlachner on 03.03.18.
//  Copyright © 2018 LonoS. All rights reserved.
//

import Foundation
import Alamofire

class ImageUpload{
    func uploadImg(img: UIImage, fullUrl: String){
        let parameters = [
            "ocrEngine": "0",
            "submit": "Upload",
            "__RequestVerificationToken": "CfDJ8PnFf_CXShpGv_pKnn2EaiMmnXVL7SSS63s_24zfYK6-0HifyXEY4Q8zFd8cbwfvgVw1yoNxTv69ka04XuRk6oEO_x0rzthXaJ2CKb-UoZdbqJyy9_2sTqiz1Sx2T5lPH9JaPoQZfxMYxtu9W1IbGpw"

        ]
        
        
        Alamofire.upload(multipartFormData:  { (multipartFormData) in
            multipartFormData.append(UIImageJPEGRepresentation(#imageLiteral(resourceName: "3391_001"), 1)!, withName: "file", fileName: "phobit\(UUID.init().uuidString)_file.jpeg", mimeType: "image/jpeg")
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        }, usingThreshold: UInt64.init() , to: fullUrl, method: HTTPMethod.post, headers: parameters, encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                    print("Progress: \(progress)")
                })
                upload.responseJSON { response in
                    print("JSON RESPONSE")
                    debugPrint(response)
                }
                upload.responseString  { response in
                    print("STRING RESPONSE")
                    debugPrint(response)
                }
            case .failure(let encodingError):
                print(encodingError)
            }
            
        })
            
        

    
    }
    
}


