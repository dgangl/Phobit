//
//  LoginTableViewCell.swift
//  Phobit
//
//  Created by Paul Krenn on 08.02.18.
//  Copyright © 2018 Paul Wiesinger. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class LoginTableViewCell: MGSwipeTableCell {
    
    
    @IBOutlet weak var firmenname: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    @IBAction func DeletPressed(_ sender: Any) {
        
        
    }
    
}

