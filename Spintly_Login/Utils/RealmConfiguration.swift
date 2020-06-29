//
//  RealmConfiguration.swift
//  Spintly_Login
//
//  Created by Kusum Pal on 25/06/20.
//  Copyright © 2020 Mrinq. All rights reserved.
//

import Foundation
import RealmSwift

class RealmConfiguration {
    
    private init() {
    }
    
    static func setupConfiguration() {
        Realm.Configuration.defaultConfiguration = Realm.Configuration(
        schemaVersion: 1,
        migrationBlock: { migration, oldSchemaVersion in
            if (oldSchemaVersion < 1) {
                migration.enumerateObjects(ofType: AccessLogModel.className()) { oldObject, newObject in
                    if (!(oldObject?.objectSchema.properties.contains(where: { $0.name == "requestUuid" }) ?? false)) {
                        newObject?["requestUuid"] = UUID().uuidString
                        newObject?["method"] = "OPEN BUTTON"
                    }
                }
            }
        })
    }
}
