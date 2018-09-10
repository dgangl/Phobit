//
//  RightViewController.swift
//  Phobit
//
//  Created by Paul Wiesinger on 28.08.18.
//  Copyright © 2018 LonoS. All rights reserved.
//

import UIKit

class RightViewController: UIViewController, SnapDelegate {
    
    func viewAppears() {
        print("RVC appeared")
    }
    
    func viewDisappears() {
        print("RVC disappeared")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
