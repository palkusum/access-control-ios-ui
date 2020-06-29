//
//  AccessBarrierModel.swift
//  Spintly
//
//  Created by Suhas Patil on 04/04/19.
//  Copyright © 2019 LeoMetric Technology. All rights reserved.
//

import Foundation

class AccessBarrierModel {
    
    
    var id: String
    var name: String
    var location: String
    var isSelected: Bool
    
    init() {
        
        id = ""
        name = ""
        location = ""
        isSelected = false
    }
    
    init(object: [String: Any]) {
        
        id = (object["id"] as? String) ?? ""
        name = (object["name"] as? String) ?? ""
        location = (object["location"] as? String) ?? ""
        isSelected = (object["isSelected"] as? Bool) ?? false
    }
    
    func toDictionary() -> [String: Any] {
        var dict = [String: Any] ()
        dict["id"] = id
        dict["name"] = name
        dict["location"] = location
        dict["isSelected"] = isSelected
        
        return dict
    }
}
