//
//  SpaltenTableViewCell.swift
//  Phobit
//
//  Created by Paul Wiesinger on 17.02.18.
//  Copyright © 2018 Paul Wiesinger. All rights reserved.
//

import UIKit

class SpaltenTableViewCell: UITableViewCell {

    @IBOutlet weak var prozent: UILabel! {
        didSet {
            prozent.font = UIFont.monospacedDigitSystemFont(ofSize: prozent.font.pointSize, weight: .regular)
        }
    }
    
    @IBOutlet weak var mwst: UILabel!{
        didSet {
            mwst.font = UIFont.monospacedDigitSystemFont(ofSize: mwst.font.pointSize, weight: .regular)
        }
    }
    
    @IBOutlet weak var netto: UILabel!{
        didSet {
            netto.font = UIFont.monospacedDigitSystemFont(ofSize: netto.font.pointSize, weight: .regular)
        }
    }
    
    @IBOutlet weak var brutto: UILabel!{
        didSet {
            brutto.font = UIFont.monospacedDigitSystemFont(ofSize: brutto.font.pointSize, weight: .regular)
        }
    }
    
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



