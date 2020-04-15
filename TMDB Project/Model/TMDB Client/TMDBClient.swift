//
//  TMDBClient.swift
//  TMDB Project
//
//  Created by ZeyadEl3ssal on 1/1/20.
//  Copyright © 2020 ZeyadEl3ssal. All rights reserved.
//

import UIKit
import Foundation

class TMDBClient: NSObject {
    
    let config = TMDBConfig()
    
    func taskForGETMethod(
        method : String ,parameters : [String : AnyObject] ,completionHandlerForGETMethod : @escaping (_ result : AnyObject? , _ error : NSError?) -> Void) -> URLSessionDataTask
    {
        let url = TMDBURLFromParameters(parameters: parameters, withPathExtension: method)
        let request = URLRequest(url: url)
        let session = URLSession.init(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: request) { (data, response, error) in
            
            func sendError(_ error:String)
            {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGETMethod(nil,NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else
            {
                sendError("There was an error in your request:\(error!)")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode , statusCode >= 200 && statusCode <= 299 else
            {
                sendError("Your request returned a status code other than 2xx")
                return
            }
            
            guard let data = data else
            {
                sendError("No data returned with your request")
                return
            }
            self.convertDataWithCompetionHandler(data: data, completionHandlerForConvertData: completionHandlerForGETMethod)
            
            
        }
        task.resume()
        return task
    }

    

    
    func convertDataWithCompetionHandler(data : Data , completionHandlerForConvertData : (_ result : AnyObject? , _ error : NSError?) -> Void)
    {
        var parsedData : AnyObject? = nil
        do
        {
            parsedData = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                as AnyObject
        }catch{
            let userInfo = [NSLocalizedDescriptionKey : "Data couldn't be parsed as JSON"]
            completionHandlerForConvertData(nil , NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        completionHandlerForConvertData(parsedData,nil)
    }
    


    private func TMDBURLFromParameters(parameters : [String : AnyObject], withPathExtension : String? = nil) -> URL
    {
        var components = URLComponents()
        components.scheme = TMDBClient.Constants.APIScheme
        components.host = TMDBClient.Constants.APIHost
        components.path = TMDBClient.Constants.APIPath + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        for (key,value) in parameters
        {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems?.append(queryItem)
        }
        return components.url!
    }
    
    class func sharedInstance() -> TMDBClient
    {
        struct Singleton
        {
            static var sharedInstance = TMDBClient()
        }
        return Singleton.sharedInstance
    }

}


