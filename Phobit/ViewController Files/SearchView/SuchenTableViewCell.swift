//
//  SuchenTableViewCell.swift
//  Phobit
//
//  Created by 73 on 09.12.17.
//  Copyright © 2017 73. All rights reserved.
//

import UIKit

class SuchenTableViewCell: UITableViewCell {
    @IBOutlet weak var firmenname: UILabel!
    @IBOutlet weak var betrag: UILabel!
    @IBOutlet weak var indicator: UIImageView!
    
    // the cellID to get the data model from the SearchObject
    var cellID: Int?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        indicator.layer.cornerRadius = indicator.frame.width/2
        indicator.clipsToBounds = true
        indicator.backgroundColor = .red
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
