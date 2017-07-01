//
//  Rest.swift
//  FlowCore
//
//  Created by Gijs van de Nieuwegiessen on 03/04/2017.
//  Copyright © 2017 Flow.ai. All rights reserved.
//

import Foundation

public class Rest {
    var endpoint:String
    
    public init(_ endpoint:String) {
       self.endpoint = endpoint
    }
    
    // MARK: - Public methods
    
    /// Make a GET call
    public func get(path:String, token:String, queryParams:[String:String]? = nil, completion: @escaping (NSError?, [String: Any]?) -> Void) {
        return call(token: token, path: path, method: "GET", queryParams: queryParams, completion: completion)
    }
    
    /// Make a POST call
    public func post(path:String, token:String, queryParams:[String:String]?, completion: @escaping (NSError?, [String: Any]?) -> Void) {
        return call(token: token, path: path, method: "POST", queryParams: queryParams, completion: completion)
    }
    
    // MARK: - Private methods
    private func call(token:String, path:String, method:String, queryParams:[String:String]? = nil, completion: @escaping (NSError?, [String: Any]?) -> Void) {
        
        let headers = self.createHeaders(token: token)
        
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = headers
    
        let session = URLSession(configuration: config)
        
        var urlstring = "\(self.endpoint)/\(path)"
        let queryString:String? = self.createQueryString(queryParams)
        if let queryString = queryString {
            urlstring.append("?\(queryString)")
        }
        
        let url = URL(string: urlstring)!
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        session.dataTask(with: request) { data, response, err in

            if err != nil {
                completion(err! as NSError, nil)
            } else {
                do {
                    let parsedData = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                    completion(nil, parsedData)
                } catch let error as NSError {
                    completion(error, nil)
                }
            }
        }.resume()
    }
    
    private func createQueryString(_ queryParams:[String:String]?) -> String? {
        // Create query params
        if let queryParams = queryParams {
            var queryString:String = ""
            for (key, value) in queryParams {
                queryString.append("\(key)=\(value)&")
            }
            
            return String(queryString.characters.dropLast(1))
        } else {
            return nil
        }
    }
    
    
    private func createHeaders(token:String) -> [AnyHashable : Any] {
        var headers = [AnyHashable : Any]()
        headers["Content-Type"] = "application/json"
        headers["Authorization"] = "Bearer \(token)"
        headers["Accept-Language"] = Locale.current.languageCode
        return headers
    }
}
