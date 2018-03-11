//
//  ResultTableViewCell.swift
//  Phobit
//
//  Created by Paul Wiesinger on 11.01.18.
//  Copyright © 2018 Paul Wiesinger. All rights reserved.
//

import UIKit

class ResultTableViewCell: UITableViewCell {

    @IBOutlet weak var firma: UILabel!
    @IBOutlet weak var bruttobetrag: UILabel!
    @IBOutlet weak var datum: UILabel!
    
    // id for dict
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
