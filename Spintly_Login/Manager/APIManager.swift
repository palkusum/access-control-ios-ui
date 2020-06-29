//
//  APIManager.swift
//  Spintly_Login
//
//  Created by Kusum Pal on 25/06/20.
//  Copyright © 2020 Mrinq. All rights reserved.
//

import Foundation
import Alamofire
import AWSCognitoIdentityProvider
import KRActivityIndicatorView

typealias APICompletion = (APIResponse) -> Void

struct APIResponse {
    var status = false
    var statusCode : Int?
    var errorMessage : String?
    var object : [String: Any]?
}

class APIManager {
    
    var pool:AWSCognitoIdentityUserPool = AWSCognitoIdentityUserPool(forKey: AWSCognitoUserPoolsSignInProviderKey)

    static var manager : APIManager?
    class func shared() -> APIManager {
        if manager == nil {
            manager = APIManager()
        }
        return manager!
    }
    
    //MARK:- POST
    func requestWith(_ endPoint : API_END_POINTS, method requestMethod : HTTPMethod, andParameters parameters : Parameters?, withCompletion completion: @escaping APICompletion) {
        
        
        self.pool.currentUser()?.getSession().continueWith { task in
            if task.error == nil {
                
                let awsSession = task.result! as AWSCognitoIdentityUserSession
                let idToken = awsSession.idToken?.tokenString
               
//                guard idToken != nil else {
//                    //TODO: SHOW THE TOKEN ERROR MESSEGE HERE
//                    return
//                }
                
                let headers = [
                    "Authorization": idToken
                    ]
                
                let postParameters = parameters! as [String: Any]
                let postString = postParameters.compactMap({ (key, value) -> String in
                    return "\(key)=\(value)"
                }).joined(separator: "&")
                
                let postData = NSMutableData(data: postString.data(using: String.Encoding.utf8)!)
                // let postData = try? JSONSerialization.data(withJSONObject: postParameters, options: .prettyPrinted)
                
                let request = NSMutableURLRequest(url: NSURL(string: String(format:"%@/%@",BASEURL,endPoint.rawValue))! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 50.0)
                
                request.allHTTPHeaderFields = headers as? [String : String]
                request.httpShouldHandleCookies = true
                request.httpMethod = requestMethod.rawValue
                request.httpBody = postData as Data
                
                let session = URLSession.shared
                let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
                    DispatchQueue.main.async {
                        let statusCode = (response as? HTTPURLResponse)?.statusCode
                        if (error != nil) {
                            //print(error!)
                            completion(APIResponse(status: false, statusCode: statusCode, errorMessage: "Oops! Check your connection and try again", object: nil))
                            
                        } else {
                            
                            let responseString = String(data: data!, encoding: .utf8)
                            var responseDict = NSDictionary.convertStringToDictionary(text: responseString!)
                            
                            if responseDict == nil
                            {
                                completion(APIResponse(status: false, statusCode: statusCode, errorMessage: "", object: nil))
                                return
                            }
                            
                            if responseDict!["type"] as! String != "success" {
                                completion(APIResponse(status: false, statusCode: statusCode, errorMessage: "", object: responseDict))
                                return
                            }
                            
                            completion(APIResponse(status: true, statusCode: statusCode, errorMessage: "", object: responseDict))
                        }
                    }
                })
                dataTask.resume()
            }
            return nil
        }
    }
    
    func requestWithJson(_ endPoint : API_END_POINTS, method requestMethod : HTTPMethod, andParameters parameters : Parameters?, withCompletion completion: @escaping APICompletion) {
        
        
        self.pool.currentUser()?.getSession().continueWith { task in
            if task.error == nil {
                
                let awsSession = task.result! as AWSCognitoIdentityUserSession
                let idToken = awsSession.idToken?.tokenString
                
                //                guard idToken != nil else {
                //                    //TODO: SHOW THE TOKEN ERROR MESSEGE HERE
                //                    return
                //                }
                
                let headers = [
                    "Authorization": idToken,
                    "content-type": "application/json",
                    "cache-control": "no-cache"
                ]
                
                let postParameters = parameters! as [String: Any]
//                let postString = postParameters.compactMap({ (key, value) -> String in
//                    return "\(key)=\(value)"
//                }).joined(separator: "&")
                
               // let postData = NSMutableData(data: postString.data(using: String.Encoding.utf8)!)
                 let postData = try? JSONSerialization.data(withJSONObject: postParameters, options: .prettyPrinted)
                
                let request = NSMutableURLRequest(url: NSURL(string: String(format:"%@/%@",BASEURL,endPoint.rawValue))! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 50.0)
                
                request.allHTTPHeaderFields = headers as? [String : String]
                request.httpShouldHandleCookies = true
                request.httpMethod = requestMethod.rawValue
                request.httpBody = (postData as! Data)
                
                let session = URLSession.shared
                let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                    
                    DispatchQueue.main.async {
                        let statusCode = (response as? HTTPURLResponse)?.statusCode

                        if (error != nil) {
                            //print(error!)
                            completion(APIResponse(status: false, statusCode: statusCode, errorMessage: "Oops! Check your connection and try again", object: nil))
                            
                        } else {
                            
                            let responseString = String(data: data!, encoding: .utf8)
                            var responseDict = NSDictionary.convertStringToDictionary(text: responseString!)
                            
                            if responseDict == nil
                            {
                                completion(APIResponse(status: false, statusCode: statusCode, errorMessage: "", object: nil))
                                return
                            }
                            
                            if responseDict!["type"] as! String != "success" {
                                completion(APIResponse(status: false, statusCode: statusCode, errorMessage: (responseDict!["message"] as! String), object: responseDict))
                                return
                            }
                            
                            completion(APIResponse(status: true, statusCode: statusCode, errorMessage: "", object: responseDict))
                        }
                    }
                })
                dataTask.resume()
            }
            return nil
        }
    }
    
    
    func requestWithUrl(_ endPoint : String, method requestMethod : HTTPMethod, andParameters parameters : Parameters?, withCompletion completion: @escaping APICompletion) {
        
        self.pool.currentUser()?.getSession().continueWith { task in
            if task.error == nil {
                
                let awsSession = task.result! as AWSCognitoIdentityUserSession
                let idToken = awsSession.idToken?.tokenString
                
                //                guard idToken != nil else {
                //                    //TODO: SHOW THE TOKEN ERROR MESSEGE HERE
                //                    return
                //                }
                
                let headers = [
                    "Authorization": idToken,
                    "cache-control": "no-cache"
                ]
                
                let postParameters = parameters! as [String: Any]
                let postData = try? JSONSerialization.data(withJSONObject: postParameters, options: .prettyPrinted)
                let request = NSMutableURLRequest(url: NSURL(string: String(format:"%@/%@",BASEURL,endPoint))! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 50.0)
                
                request.allHTTPHeaderFields = headers as? [String : String]
                request.httpMethod = requestMethod.rawValue
                request.httpBody = (postData as! Data)
               
                let session = URLSession.shared
                let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                    
                    DispatchQueue.main.async {
                        let statusCode = (response as? HTTPURLResponse)?.statusCode
                        if (error != nil) {
                            //print(error!)
                            completion(APIResponse(status: false, statusCode: statusCode, errorMessage: "Oops! Check your connection and try again", object: nil))
                            
                        } else {
                            
                            let responseString = String(data: data!, encoding: .utf8)
                            var responseDict = NSDictionary.convertStringToDictionary(text: responseString!)
                            
                            if responseDict == nil
                            {
                                completion(APIResponse(status: false, statusCode: statusCode, errorMessage: "", object: nil))
                                return
                            }
                            
                            if responseDict!["type"] as! String != "success" {
                                completion(APIResponse(status: false, statusCode: statusCode, errorMessage: (responseDict!["message"] as? String ?? UIMessages.API_RESPOSNE_FAILED), object: responseDict))
                                return
                            }
                            
                            completion(APIResponse(status: true, statusCode: statusCode, errorMessage: "", object: responseDict))
                        }
                    }
                })
                dataTask.resume()
            }
            return nil
        }
    }
    
    func postRequestWithJsonUrl(_ endPoint : String, method requestMethod : HTTPMethod, andParameters parameters : Parameters?, withCompletion completion: @escaping APICompletion) {
        
        self.pool.currentUser()?.getSession().continueWith { task in
            if task.error == nil {
                
                let awsSession = task.result! as AWSCognitoIdentityUserSession
                let idToken = awsSession.idToken?.tokenString
                
                //                guard idToken != nil else {
                //                    //TODO: SHOW THE TOKEN ERROR MESSEGE HERE
                //                    return
                //                }
                
                let headers = [
                    "Authorization": idToken,
                    "content-type": "application/json",
                    "cache-control": "no-cache"
                ]
                
                let postParameters = parameters! as [String: Any]
                let postData = try? JSONSerialization.data(withJSONObject: postParameters, options: .prettyPrinted)
                let request = NSMutableURLRequest(url: NSURL(string: String(format:"%@/%@",BASEURL,endPoint))! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 50.0)
                
                request.allHTTPHeaderFields = headers as? [String : String]
                request.httpShouldHandleCookies = true
                request.httpMethod = requestMethod.rawValue
                request.httpBody = (postData as! Data)
                
                let session = URLSession.shared
                let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                    
                    DispatchQueue.main.async {
                        let statusCode = (response as? HTTPURLResponse)?.statusCode
                        if (error != nil) {
                            //print(error!)
                            completion(APIResponse(status: false, statusCode: statusCode, errorMessage: "Oops! Check your connection and try again", object: nil))
                            
                        } else {
                            
                            let responseString = String(data: data!, encoding: .utf8)
                            var responseDict = NSDictionary.convertStringToDictionary(text: responseString!)
                            
                            if responseDict == nil
                            {
                                completion(APIResponse(status: false, statusCode: statusCode, errorMessage: "", object: nil))
                                return
                            }
                            
                            if responseDict!["type"] as? String != "success" {
                                completion(APIResponse(status: false, statusCode: statusCode, errorMessage: (responseDict!["message"] as! String), object: responseDict))
                                return
                            }
                            
                            completion(APIResponse(status: true, statusCode: statusCode, errorMessage: "", object: responseDict))
                        }
                    }
                })
                dataTask.resume()
            }
            return nil
        }
    }
    
    //MARK:- GET METHODS
    func getRequestWithUrl(_ endPoint : String, method requestMethod : HTTPMethod, andParameters parameters : Parameters?, withCompletion completion: @escaping APICompletion) {
        
        
        self.pool.currentUser()?.getSession().continueWith { task in
            if task.error == nil {
                
                let awsSession = task.result! as AWSCognitoIdentityUserSession
                let idToken = awsSession.idToken?.tokenString
                
                //                guard idToken != nil else {
                //                    //TODO: SHOW THE TOKEN ERROR MESSEGE HERE
                //                    return
                //                }
                
                let headers = [
                    "Authorization": idToken,
                    "cache-control": "no-cache"
                ]
                
                let request = NSMutableURLRequest(url: NSURL(string: String(format:"%@/%@",BASEURL,endPoint))! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 50.0)
                
                request.allHTTPHeaderFields = headers as? [String : String]
                request.httpMethod = requestMethod.rawValue
                
                let session = URLSession.shared
                let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                    
                    DispatchQueue.main.async {
                        let statusCode = (response as? HTTPURLResponse)?.statusCode
                        if (error != nil) {
                            //print(error!)
                            completion(APIResponse(status: false, statusCode: statusCode, errorMessage: "Oops! Check your connection and try again", object: nil))
                            
                        } else {
                            
                            let responseString = String(data: data!, encoding: .utf8)
                            var responseDict = NSDictionary.convertStringToDictionary(text: responseString!)
                            
                            if responseDict == nil
                            {
                                completion(APIResponse(status: false, statusCode: statusCode, errorMessage: "", object: nil))
                                return
                            }
                            
                            if responseDict!["type"] as! String != "success" {
                                completion(APIResponse(status: false, statusCode: statusCode, errorMessage: (responseDict!["message"] as! String), object: responseDict))
                                return
                            }
                            if responseDict!["type"] as? String != "success" {
                                completion(APIResponse(status: false, statusCode: statusCode, errorMessage: (responseDict!["message"] as? String ?? UIMessages.API_RESPOSNE_FAILED), object: responseDict))
                                return
                            }
                            
                            completion(APIResponse(status: true, statusCode: statusCode, errorMessage: "", object: responseDict))
                            
                        }
                    }
                })
                dataTask.resume()
            }
            return nil
        }
    }
}

