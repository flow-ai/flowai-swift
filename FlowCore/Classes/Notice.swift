//
//  Notice.swift
//  flow.ai
//
//  Created by Gijs van de Nieuwegiessen on 06/04/2017.
//
//

import Foundation
import HandyJSON

struct Notice : HandyJSON {
    
    private(set) public var threadId:String!
    
    init() {}
    
    init(_ threadId:String) {
        self.threadId = threadId
    }
}
