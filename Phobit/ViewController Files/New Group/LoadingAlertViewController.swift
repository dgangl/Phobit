//
//  LoadingAlertViewController.swift
//  Phobit
//
//  Created by Paul Wiesinger on 12.07.18.
//  Copyright © 2018 LonoS. All rights reserved.
//

import UIKit

class LoadingAlertViewController: UIViewController {

    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    var webservice: WebService?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        message.text = RandomLoadingMessages.init().message
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        webservice?.cancelUploadFromUser()
        self.dismiss(animated: false, completion: nil)
    }
}
