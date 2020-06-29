//
//  iphoneData.swift
//  Spintly_Login
//
//  Created by Kusum Pal on 25/06/20.
//  Copyright © 2020 Mrinq. All rights reserved.
//

import Foundation
import UIKit

struct iPhoneData : Hashable, Codable {
    
    let version : String
    let model: String
    let name: String
    let appVersion: String
    let appBuildNumber: String
        
    static func getCurrentDeviceDetails() -> iPhoneData {
        return iPhoneData(version: UIDevice.current.systemVersion,
                          model: UIDevice.current.model,
                          name: UIDevice.current.name,
                          appVersion: Bundle.main.versionNumber ?? "",
                          appBuildNumber: Bundle.main.buildNumber ?? ""
        )
    }

}
