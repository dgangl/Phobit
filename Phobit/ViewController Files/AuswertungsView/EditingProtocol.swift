//
//  EditingProtocol.swift
//  Phobit
//
//  Created by Paul Wiesinger on 17.02.18.
//  Copyright © 2018 Paul Wiesinger. All rights reserved.
//

import Foundation

protocol EditingProtocol {
    func userDidEdit(inIndexPath indexPath: IndexPath, changedText text: String?)
}
