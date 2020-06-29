//
//  NotificationConstants.swift
//  Spintly_Login
//
//  Created by Kusum Pal on 25/06/20.
//  Copyright © 2020 Mrinq. All rights reserved.
//

import Foundation

extension Notification.Name {
    
    static let REMOTE_UNLOCK_ACK = Notification.Name(Bundle.main.bundleIdentifier! + ".REMOTE_UNLOCK_ACK")
    static let REGISTER_REMOTE_NOTIFICATION_STATUS = Notification.Name(Bundle.main.bundleIdentifier! + ".REGISTER_REMOTE_NOTIFICATION_STATUS")
    
}
