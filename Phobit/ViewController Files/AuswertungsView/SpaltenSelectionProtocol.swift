//
//  SpaltenSelectionProtocol.swift
//  Phobit
//
//  Created by Paul Wiesinger on 18.02.18.
//  Copyright © 2018 Paul Wiesinger. All rights reserved.
//

import Foundation

protocol SpaltenSelectionProtocol {
    
    //matrixnumber = (row, column)
    func textFieldInCellSelected(matrixNumber matrix: (Int, Int))
    
    func finishedEditing(forMatrix: (Int,Int), text: String)
}
