//
//  SuchenTableViewCell.swift
//  Phobit
//
//  Created by LonoS on 09.12.17.
//  Copyright © 2017 LonoS. All rights reserved.
//

import UIKit

class SuchenTableViewCell: UITableViewCell {
    @IBOutlet weak var firmenname: UILabel!
    @IBOutlet weak var betrag: UILabel!
    
    // the cellID to get the data model from the SearchObject
    var cellID: Int?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
