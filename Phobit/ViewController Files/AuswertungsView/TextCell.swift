//
//  TextCell.swift
//  Phobit
//
//  Created by 73 on 21.12.17.
//  Copyright © 2017 73. All rights reserved.
//

import UIKit

class TextCell: UITableViewCell{

    
    @IBOutlet weak var textField: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
