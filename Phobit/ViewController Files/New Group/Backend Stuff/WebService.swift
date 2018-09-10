//
//  WebService.swift
//  Phobit
//
//  Created by 73 on 24.04.18.
//  Copyright © 2018 73. All rights reserved.
//

import Foundation
import Alamofire
import UIKit


class WebService {
    
    let urlOCR = "https://services.rzlsoftware.at/rzlocrservice/Home/DoOCR"
    let urlBasic = "https://services.rzlsoftware.at/rzlocrservice"
    
    
    fileprivate var uploadRequest: Request?
    fileprivate var isAllowedToCancel = true
    fileprivate var systemCancelled = false
    
    // the image to be sent.
    let image: UIImage
    
    var token: String? = nil
    
    init(image: UIImage) {
        self.image = image
    }
    
    
    func start(completion: @escaping (_ result: String, _ statusCode: WebServiceStatus) -> (), progressView: UIProgressView? = nil) {
        // 1. get the current token from the server
        
        getRequestVerificationToken { (data) in
            // 2. set the token
            self.setDataToToken(token: data)
            // 3. upload the image and wait for response
//            self.send(completion: { (response, statusCode) in
//                // 4. passing the parameters to our completion handler
//                completion(response, statusCode, progressView)
//            })
            self.send(completion: { (response, statusCode) in
                completion(response, statusCode)
            }, progressView: progressView)
        }
        
        
        
    }
    
    
    
    
    
    
    
    
    fileprivate func getRequestVerificationToken(completion: @escaping (_ tokenData: Data?) -> ()) {
        
        let task = URLSession.shared.dataTask(with: URL.init(string: urlBasic)!) { (data, response, error) in
            if let error = error {
                print("WEBSERVICE: Error in getRequestVerificationToken()")
                print("---------------")
                print(error)
                print("---------------")
              
            }
            
            
            guard let data = data else {
                print("WEBSERVICE: Error in getRequestVerificationToken(): data is nil")
                print("---------------")
        
                completion(nil)
                return
            }
            
            completion(data)
            
        }
        
        task.resume()
        
        
    }
    
    
    
    
    
    fileprivate func setDataToToken(token: Data?) {
        
        guard let token = token else {
            return
        }
        
        let rawString = String.init(data: token, encoding: String.Encoding.utf8)
        
        let rawSplitArray = rawString?.components(separatedBy: "<input name=\"__RequestVerificationToken\" type=\"hidden\" value=\"")
        let finishedToken = rawSplitArray![1].components(separatedBy: "\"")[0]
        
        self.token = finishedToken
    }
    
    
    
    
 
    fileprivate func send(completion: @escaping (_ result: String, _ statusCode: WebServiceStatus)->(), progressView: UIProgressView?) {
      
        guard let token = self.token else {
            print("WEBSERVICE: it seems that we have no Internet connection.")
            completion("", WebServiceStatus.systemCancelled)
            return
        }
        
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 20) {
            self.cancelUploadInternal()
        }
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append("0".data(using: .utf8)!, withName: "ocrEngine")
                multipartFormData.append("Upload".data(using: .utf8)!, withName: "submit")
                multipartFormData.append("\(token)".data(using: .utf8)!, withName: "__RequestVerificationToken")
                multipartFormData.append(UIImagePNGRepresentation(self.image)!, withName: "file", fileName: "3391_001.png", mimeType: "image/png")
        },
            to: urlOCR,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(request: let upload, streamingFromDisk: _, streamFileURL: _):
                    
                    
                    self.uploadRequest = upload
                    
                    
                    if let progressView = progressView {
                        upload.uploadProgress { progress in
                            progressView.setProgress(Float(progress.fractionCompleted), animated: true)
                            print("#################\(progress.fractionCompleted)")
                        }
                    } else {
                        upload.uploadProgress { progress in
                            print("#################\(progress.fractionCompleted)")
                        }
                    }
                    
                    
                    upload.responseData(completionHandler: { (data) in
                        
                        self.isAllowedToCancel = false
                        
                        print("RZL-Server Response")
                        print("----------------")
                        print(String.init(data: data.data!, encoding: .utf8)!)
                        print("----------------")
                        
                        let statusCode: Int? = upload.response?.statusCode
                        
                        var status: WebServiceStatus? = nil
                        
                        if let statusCode = statusCode {
                            status = WebServiceStatus.normal
                        } else if self.systemCancelled {
                            status = WebServiceStatus.timeout
                        } else {
                            status = WebServiceStatus.userCancelled
                        }
                        
                        
                        completion(String.init(data: data.data!, encoding: .utf8)!, status!)
                    })
                case .failure(let encodingError):
                    print(encodingError)
                }
        }
        )
        
    }
    
    
    func cancelUploadFromUser() {
        if isAllowedToCancel {
            uploadRequest?.cancel()
            uploadRequest = nil
            print("----- UPLOAD CANCELED FROM USER")
        }
    }
    
    
    fileprivate func cancelUploadInternal() {
        if isAllowedToCancel {
            uploadRequest?.cancel()
            uploadRequest = nil
            systemCancelled = true
            print("----- UPLOAD CANCELED FROM SYSTEM")
        }
    }
    
    
}


// response...
enum WebServiceStatus {
    case normal
    case userCancelled
    case systemCancelled
    case timeout
}
