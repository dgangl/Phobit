//
//  LoadingAlertViewController.swift
//  Phobit
//
//  Created by Paul Wiesinger on 12.07.18.
//  Copyright © 2018 LonoS. All rights reserved.
//

import UIKit
import AVFoundation

class LoadingAlertViewController: UIViewController {

    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var messageView: UIView!
    
    var webservice: WebService?
    var session: AVCaptureSession?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        message.text = RandomLoadingMessages.init().message
        message.adjustsFontSizeToFitWidth = true
        
        // animating the Message in.
        messageView.transform = CGAffineTransform.init(scaleX: 1.1, y: 1.1)
        UIView.animate(withDuration: 0.2, animations: {
            self.messageView.transform = CGAffineTransform.identity
        })
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        webservice?.cancelUploadFromUser()
        self.dismiss(animated: false, completion: {
            self.session?.startRunning()
        })
    }
}
