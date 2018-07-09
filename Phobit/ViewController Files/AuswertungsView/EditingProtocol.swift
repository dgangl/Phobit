//
//  EditingProtocol.swift
//  Phobit
//
//  Created by 73 on 17.02.18.
//  Copyright © 2018 73. All rights reserved.
//

import Foundation

protocol EditingProtocol {
    func userDidEdit(inIndexPath indexPath: IndexPath, changedText text: String?)
}
