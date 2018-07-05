//
//  addSteuerzeileTableViewCell.swift
//  Phobit
//
//  Created by Julian Kronlachner on 04.07.18.
//  Copyright © 2018 LonoS. All rights reserved.
//

import UIKit

class addSteuerzeileTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(notifySuperview)))

    }
    
    @IBAction func addSteuerzeile(_ sender: Any) {
        notifySuperview()
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    @objc func notifySuperview(){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "addSteuerzeile"), object: nil)
        print("addSteuerzeileTableViewCell notified AuswertungsTableViewController")
        
    }

}
