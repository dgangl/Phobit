//
//  SpaltenTableViewCell.swift
//  Phobit
//
//  Created by Paul Wiesinger on 17.02.18.
//  Copyright © 2018 Paul Wiesinger. All rights reserved.
//

import UIKit

class SpaltenTableViewCell: UITableViewCell {

    @IBOutlet weak var prozent: UILabel!
    @IBOutlet weak var mwst: UILabel!
    @IBOutlet weak var netto: UILabel!
    @IBOutlet weak var brutto: UILabel!
    
    var delegate: SpaltenSelectionProtocol?
    var row: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        prozent.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(prozentTouched)))
        mwst.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(mwstTouched)))
        netto.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(nettoTouched)))
        brutto.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(bruttoTouched)))
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @objc func prozentTouched() {
        informDelegate(id: 0)
 
    }
    
    @objc func mwstTouched() {
        informDelegate(id: 2)
    }
    
    @objc func nettoTouched() {
        informDelegate(id: 1)
    }
    
    @objc func bruttoTouched() {
        informDelegate(id: 3)
    }
    // inform the delegate about which cell got touched, for more information about this ask wieses about his notes.
    func informDelegate(id: Int) {
        delegate?.textFieldInCellSelected(matrixNumber: (row!, id))
    }
}



