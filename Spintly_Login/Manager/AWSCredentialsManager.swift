//
//  AWSCredentialsManager.swift
//  Spintly_Login
//
//  Created by Kusum Pal on 25/06/20.
//  Copyright © 2020 Mrinq. All rights reserved.
//

import Foundation
import AWSCognitoIdentityProvider

class AWSCredentialsManager {
    static let shared = AWSCredentialsManager()
    let userPool : AWSCognitoIdentityUserPool
    
    var currentUser : AWSCognitoIdentityUser? {
        get {
            userPool.currentUser()
        }
    }
    
    private init() {
        let serviceConfiguration = AWSServiceConfiguration(region: CognitoIdentityUserPoolRegion, credentialsProvider: nil)
        
        // create pool configuration
        let poolConfiguration = AWSCognitoIdentityUserPoolConfiguration(clientId: CognitoIdentityUserPoolAppClientId,clientSecret: nil,poolId: CognitoUserPoolId)
        
        // initialize user pool client
        AWSCognitoIdentityUserPool.register(with: serviceConfiguration, userPoolConfiguration: poolConfiguration, forKey: AWSCognitoUserPoolsSignInProviderKey)
        
        userPool = AWSCognitoIdentityUserPool(forKey: AWSCognitoUserPoolsSignInProviderKey)
        
        let credentialsProvider = AWSCognitoCredentialsProvider(
            regionType: CognitoIdentityUserPoolRegion, identityPoolId: CognitoIdentityUserPoolId)
        let defaultServiceConfiguration = AWSServiceConfiguration(
            region: CognitoIdentityUserPoolRegion, credentialsProvider: credentialsProvider)
        defaultServiceConfiguration?.maxRetryCount = 0
        AWSServiceManager.default().defaultServiceConfiguration = defaultServiceConfiguration

    }
    
    func resetUserPoolDelegate() {
        class AWSCognitoIdentityInteractiveAuthenticationDelegateIMPL : NSObject, AWSCognitoIdentityInteractiveAuthenticationDelegate {
            
        }
        userPool.delegate = AWSCognitoIdentityInteractiveAuthenticationDelegateIMPL()
    }
    
    func checkIfUserSignedUp(_ username : String,  completion : @escaping (_ isSignedUp: Bool?, _ error: Error?) -> ()) {
        let user = userPool.getUser(username)
        user.confirmSignUp("0").continueWith(block: { (task) -> Any? in
            DispatchQueue.main.async {
                if let error = task.error as NSError? {
                    print(username)
                    print(error)
                    if error.domain == AWSCognitoIdentityProviderErrorDomain {
                        if let errorType = AWSCognitoIdentityProviderErrorType(rawValue: error.code) {
                            if errorType == AWSCognitoIdentityProviderErrorType.userNotFound {
                                completion(false, nil)
                            } else {
                                completion(true, nil)
                            }
                        }
                        else {
                            //Should never come here
                            completion(nil, error)
                        }
                    }
                    else {
                        completion(nil, error)
                    }
                    
                } else {
                    //Invalid case. Will always fail
                }
            }
            return nil
        })
    }
    
    
}
