//
//  PostConnection.swift
//  Wordly
//
//  Created by eposta developer on 30/06/16.
//  Copyright © 2016 Renkli Fikirler. All rights reserved.
//

import Foundation


class PostConnection {
    
    final let logTag : String = "PostConnection"
    weak var delegate = ConnectionDelegate?()
    
    
    func makePostConnection(postParams : [String : String], subDomain:String ){
        
        // Setup the session to make REST POST call
        let postEndpoint: String = HttpLink.HTTP_LINK + subDomain
        debugPrint("url : \(postEndpoint)")
        let url = NSURL(string: postEndpoint)!
        let session = NSURLSession.sharedSession()
        
        // Create the request
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(postParams, options: [])
            print(postParams)
        } catch {
            debugPrint("bad things happened")
        }
        // Make the POST call and handle it in a completion handler
        session.dataTaskWithRequest(request, completionHandler: { ( data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            // Make sure we get an OK response
            guard let realResponse = response as? NSHTTPURLResponse where
                realResponse.statusCode == 200 else {
                    debugPrint("Not a 200 response")
                    return
            }
            
            
            
            let json = JSON(data: data! )
            //let json = NSString(data:data!, encoding: NSUTF8StringEncoding) as? String
            // debugPrint("json : \(json) ")
            
            let error = json[FinalString.ERROR].string
            debugPrint("ERROR : \(error)")
            
            if error?.lowercaseString == FinalString.ERROR_TRUE{
                //There is a error in json  response
                let mesg =  json[FinalString.MESSAGE].string
                debugPrint("MESSAGE : \(mesg)")
                
                if  self.delegate != nil {
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.delegate?.getError(mesg!)
                    })}
                
            }
            else if error?.lowercaseString == FinalString.ERROR_NULL {
                // This is valid response in order to use
                //read json data ,convert to string ,then send to service
                if let postString = NSString(data:data!, encoding: NSUTF8StringEncoding) as? String {
                    // Print what we got from the call
                    debugPrint("POST: " + postString)
                    if  self.delegate != nil {
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.delegate?.getJson(subDomain,jsonData: data!)
                        })
                        
                    }
                    
                }
            }
            else {
                //there is big problem here json format is non-valid.
                debugPrint("ERROR JSON FORMAT!")
            }
            
            
        }).resume()
        
    }
    
}


