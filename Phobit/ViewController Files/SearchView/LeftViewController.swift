//
//  LeftViewController.swift
//  Phobit
//
//  Created by Paul Wiesinger on 10.09.18.
//  Copyright © 2018 LonoS. All rights reserved.
//

import UIKit

class LeftViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let tabbarVC = SavedTabBarController()
        tabbarVC.loadView()
        addChildViewController(tabbarVC)
        view.addSubview(tabbarVC.view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
