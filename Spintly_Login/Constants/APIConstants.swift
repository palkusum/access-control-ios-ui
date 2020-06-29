//
//  APIConstants.swift
//  Spintly_Login
//
//  Created by Kusum Pal on 25/06/20.
//  Copyright © 2020 Mrinq. All rights reserved.
//

import Foundation
import AWSCognitoIdentityProvider

//MARK: AWS COGNITO

let CognitoIdentityUserPoolAppClientSecret = ""
let AWSCognitoUserPoolsSignInProviderKey = "UserPool"


//#if PRODUCTION
//let CognitoIdentityUserPoolRegion: AWSRegionType = .APSouth1
//let CognitoUserPoolId = "ap-south-1_FJvXB4KPj"
//let CognitoIdentityUserPoolId = "ap-south-1:beb335f1-fc1e-44ce-af9d-d3a5adb7a5a9"
//let CognitoIdentityUserPoolAppClientId = "1uihkq0786qf0svb5m96nmph6i"
//let SNSPlatformApplicationArn = "arn:aws:sns:ap-south-1:245891355135:app/APNS/smart-access-ios"
//let BASEURL = "https://ba3r1c2cg7.execute-api.ap-south-1.amazonaws.com/production"
//#else

// ______ DEVELOPMENT ______
let CognitoIdentityUserPoolRegion: AWSRegionType = .APSouth1
let CognitoUserPoolId = "ap-south-1_O1LBbqfF5"
let CognitoIdentityUserPoolId = "ap-south-1:2976a593-93f8-4675-a7ef-f123a5b78085"
let CognitoIdentityUserPoolAppClientId = "7pkoe9bfibqgk7si82r67mpnhj"
//#if DEBUG
//let SNSPlatformApplicationArn = "arn:aws:sns:ap-south-1:245891355135:app/APNS_SANDBOX/smart-access-ios-dev"
//#else
let SNSPlatformApplicationArn = "arn:aws:sns:ap-south-1:245891355135:app/APNS/smart-access-ios-dev-release"
//#endif
let BASEURL = "https://ba3r1c2cg7.execute-api.ap-south-1.amazonaws.com/dev"
//#endif


//MARK: API
let TERMS_URL = "http://spintly-weblinks.s3-website.ap-south-1.amazonaws.com/terms_conditions.html"
let PRIVACY_URL = "http://spintly-weblinks.s3-website.ap-south-1.amazonaws.com/privacy_policy.html"

enum API_END_POINTS: String {
    
    case SIGNIN_API = "sign-in?client=mobile"
    case HELP_SUPPORT_API = "users/help_support"
    case USERS_PERMISSION_LIST = "users/permissions/list"
    
}

enum PUSHNOTIFICATION_TYPE: String {
    
    case ACCESS_CHANGE_NOTIF = "ACCESS_CHANGE_NOTIF"
    case REMOVE_ORG_NOTIF = "REMOVE_ORG_NOTIF"
    case UPDATE_ORG_USER_DATA = "UPDATE_ORG_USER_DATA"
    case REMOTE_UNLOCK_ACK = "REMOTE_UNLOCK_ACK"
    case USER_FORCE_SIGNOUT = "USER_FORCE_SIGNOUT"
    
}

enum USER_PRIVILEGE : String {
    case end_user
    case admin
    case manager
    
    var description : String {
        get {
            switch self {
            case .end_user:
                return "End User"
            case .admin:
                return "Administrator"
            case .manager:
                return "Manager"
            }
        }
    }
}

