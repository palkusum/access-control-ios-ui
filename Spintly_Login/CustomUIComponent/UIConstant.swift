//
//  UIConstant.swift
//  Spintly_Login
//
//  Created by Kusum Pal on 25/06/20.
//  Copyright © 2020 Mrinq. All rights reserved.
//

import Foundation
import UIKit

struct UICC {//UIConstraintConstants {
    

    static let ZERO_SPACE = CGFloat(0.0)

    static let MARGIN_SPACE_2 = CGFloat(2.0)
    static let MARGIN_SPACE_4 = CGFloat(4.0)
    static let MARGIN_SPACE_8 = CGFloat(8.0)
    static let MARGIN_SPACE_16 = CGFloat(16.0)
    static let MARGIN_SPACE_32 = CGFloat(32.0)

    static let BUTTON_HEIGHT = CGFloat(45.0)
    static let TEXTIFLED_HEIGHT = CGFloat(45)
    static let BUTTON_ADD_HEIGHT_WIDTH = CGFloat(60.0)
    static let SEARCHBAR_HEIGHT = CGFloat(49.0)

    static let BG_IMAGEVIEW_HEIGHT = CGFloat(250)
    
    static let NAVIGATION_BAR_HEIGHT = CGFloat(64)
    static let TABLE_VIEW_CELL_HEIGHT = CGFloat(49)
    static let TABLE_VIEW_SECTION_HEIGHT = CGFloat(30)
    static let TABLE_VIEW_FOOTER_HEIGHT = CGFloat(49)
    static let TABLE_VIEW_CELL_IMAGE_HEIGHT_WIDTH = CGFloat(49)

}


struct UIMessages {
    
    static let COMPANY_NAME = "Spintly Smart Access"

    static let TOAST_DURATION_TIME:TimeInterval = 3.0
    
    static let ENTER_PHONE = "Enter Phone!"
    static let ENTER_VALID_LENGTH_PHONE = "Entered Phone Number is Not Valid!"
    static let ENTER_PASSWORD = "Enter Password!"
    static let ENTER_CONFIRM_PASSWORD = "Enter Confirm Password!"
    static let PASSOWRD_CONFIRMPASS_NOT_MATCH = "Password and Confirm Password Not Matching!"
    static let ENTER_PASSWORD_LENGTH = "Enter minimum 8 character password!"
    static let ENTER_OTP = "Enter OTP!"

    static let ENTER_FULLNAME = "Enter Full Name!"
    static let ENTER_EMAIL = "Enter Email!"
    static let CONFIRM_LOGOUT = "Are you sure you want to Logout?"

    static let SELECTE_USER_ROLE = "Select Role!"
    static let SELECTE_ACCESS_BARRIERS = "Select Access Barriers!"
    static let SELECT_ACCESS_MEDIUM = "Select Access Medium!"

    static let NO_ORGANISATION = "You are not part of any organisation"
    
    static let VISITOR_DELETED_SUCCESSFULLY = "Visitor Deleted!"

    static let API_RESPOSNE_FAILED = "Request Failed"

}

struct UIData {
    
    static let CONTACT_NUMBER = "+918766812888"
    static let CONTACT_EMAIL = "support@spintly.com"
    static let CONTACT_ADDRESS = "Spintly \nc/o Mring Technologies \nG1, Vaz Building, \nFatorda, Salcette, \nGoa - 403602, India"
    static let CONTACT_LAT = "15.2903859"
    static let CONTACT_LONG = "73.9622923"
    static let CONTACT_GOOGLE_MAP = "https://www.google.com/maps/place/Mrinq+Technologies+LLP/@15.2903807,73.9622923,17z/data=!3m1!4b1!4m5!3m4!1s0x3bbfb16400000001:0x9b94617d403851f8!8m2!3d15.2903807!4d73.964481"

    static let DOOR_ENTRY = "entry"
    static let DOOR_EXIT = "exit"
    static let DOOR_OPENED = "opened"

}

struct UIValidations {
    
    static let PASSWORD_MAX_LENGTH = 8
    static let LOAD_MORE_COUNT_LENGTH = 10

    static let POPUP_REMOVAL_AUTOMATIC_TIME = 2.0

}


struct NotificationNames {
    
    static let ORGANISATION_CHANGED = "ORGANISATION_CHANGED"
    static let VISITOR_DELETED = "VISITOR_DELETED"
    static let VISITOR_ADDED = "VISITOR_ADDED"

}


struct DateFormats {
    
    static let  API_DATE_FORMAT = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    static let  API_TIME_FORMAT = "HH:mm"
    static let  API_TIME_FORMAT_TIME_ZONE = "HH:mm Z"

    static let  DATE_FORMAT_DATE = "yyyy-MM-dd"
    static let  DATE_FORMAT_MONTH = "MMM"
    static let  DATE_FORMAT_DAY = "dd"
    static let  DATE_FORMAT_TIME = "hh:mm a"
    static let  DATE_FORMAT_DATE_BUTTON = "dd MMM yyyy"
    static let  DATE_FORMAT_WEEK_BUTTON = "EEEE, dd MMM YYY"

    static let  DATE_FORMAT_DATE_VISITOR_DETAIL = "MMM dd, yyyy"

    static let  DATE_TIME_ZONE_FORMAT = "yyyy-MM-dd HH:mm:ss ZZZZZ"

}
