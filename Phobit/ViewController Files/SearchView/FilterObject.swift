//
//  FilterObject.swift
//  Phobit
//
//  Created by Paul Wiesinger on 11.01.18.
//  Copyright © 2018 Paul Wiesinger. All rights reserved.
//

import Foundation

class FilterObject {
    var array = [SearchDataModel]()
    
    func add(model: SearchDataModel) {
        array.append(model)
    }
    
    func hasMembers() -> Bool {
        if array.count != 0 {
            return true
        } else {
            return false
        }
    }
    
    func sort() {
        // sort after type here.
    }
    
    
    // tableView reloading
    func getSections() -> Int {
        return 1
    }
    
    func numberOfRowsInSection(index: IndexPath) -> Int {
        return array.count
    }
    
    func getObject(byCellID id: Int) -> (SearchDataModel, Int) {
        return (array[id], array[id].dictID)
    }
}
