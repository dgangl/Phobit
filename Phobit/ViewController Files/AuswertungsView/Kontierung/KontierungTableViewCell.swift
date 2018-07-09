//
//  KontierungTableViewCell.swift
//  Phobit
//
//  Created by 73 on 19.02.18.
//  Copyright © 2018 73. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class KontierungTableViewCell:  MGSwipeTableCell{

    @IBOutlet weak var kontobezeichnung: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
