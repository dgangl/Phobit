//
//  DateUtilities.swift
//  Phobit
//
//  Created by 73 on 13.03.18.
//  Copyright © 2018 73. All rights reserved.
//

import Foundation

extension Date {
    
    
    // runtime measurement.
    
    // KÖNNTE AUF 32-bit geräten crashen...?
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
}
