//
//  AttributeModel.swift
//  Spintly_Login
//
//  Created by Kusum Pal on 25/06/20.
//  Copyright © 2020 Mrinq. All rights reserved.
//

import Foundation

class AttributeModel {
    var id : Int
    var attributeName : String
    var values : [String]
    
    init() {
        id = 0
        attributeName = ""
        values = []
    }
    
    init(object : [String : Any]) {
        id = object["id"] as? Int ?? 0
        attributeName = object["attributeName"] as? String ?? object["key"] as? String ?? ""
        values = object["values"] as? [String] ?? []
    }
    
    func toDictionary() -> [String : Any] {
        var dict = [String : Any]()
        dict["id"] = id
        dict["attributeName"] = attributeName
        dict["values"] = values
        return dict
    }
}
