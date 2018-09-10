//
//  CachedTableViewController.swift
//  Phobit
//
//  Created by Paul Wiesinger on 10.09.18.
//  Copyright © 2018 LonoS. All rights reserved.
//

import UIKit

class CachedTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
     
        // Snap View controller
        NotificationCenter.default.addObserver(self, selector: #selector(appears), name: NSNotification.Name(rawValue: AppearDisappearManager.getAppearString(id: 0)), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(disappears), name: NSNotification.Name(rawValue: AppearDisappearManager.getDisappearString(id: 0)), object: nil)
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = title
        
        self.navigationItem.rightBarButtonItems =  [UIBarButtonItem.init(barButtonSystemItem: .camera, target: self, action: #selector(pageBack)), UIBarButtonItem.init(title: "Zurück", style: .plain, target: self, action: #selector(pageBack))]
    }

    @objc func pageBack(){
        AppDelegate.snapContainer.scrollToPage(1)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    
    
    @objc func appears() {
        
    }

    @objc func disappears() {
        
    }
}
