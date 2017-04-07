//
//  Metadata.swift
//  FlowCore
//
//  Created by Gijs van de Nieuwegiessen on 03/04/2017.
//  Copyright © 2017 Flow.ai. All rights reserved.
//

import Foundation
import HandyJSON


public class Metadata : HandyJSON {
    
    private(set) public var contexts:[String] = []
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
