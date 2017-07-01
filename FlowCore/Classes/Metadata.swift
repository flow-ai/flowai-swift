//
//  Metadata.swift
//  FlowCore
//
//  Created by Gijs van de Nieuwegiessen on 03/04/2017.
//  Copyright © 2017 Flow.ai. All rights reserved.
//

import Foundation
import HandyJSON


/// Data you send with a Message
public class Metadata : HandyJSON {
    
    /// Language of the message
    public var language:String?
    
    /// Timezone of the message (number of hours from UTC)
    public var timezone:Int?
    
    /// Context of the message
    private(set) public var contexts:[String] = []
    
    /// Variables to use in backed code
    private(set) public var params:[String: String] = [:]
    
    required public init() {}
    
    init(_ data: [String: Any]) {
        if let contexts = data["contexts"] as? [String] {
            self.contexts = contexts
        }
        
        if let params = data["params"] as? [String: String] {
            self.params = params
        }
    }
    
    public func addContext(context:String) {
        contexts.append(context)
    }
    
    public func addParam(key:String, value:String) {
        params[key] = value
    }
}
