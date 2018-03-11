//
//  KontierungTableViewCell.swift
//  Phobit
//
//  Created by Paul Wiesinger on 19.02.18.
//  Copyright © 2018 Paul Wiesinger. All rights reserved.
//

import UIKit

class KontierungTableViewCell: UITableViewCell {

    @IBOutlet weak var kontonummer: UILabel!
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
