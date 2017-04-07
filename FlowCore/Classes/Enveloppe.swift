//
//  Enveloppe.swift
//  flow.ai
//
//  Created by Gijs van de Nieuwegiessen on 06/04/2017.
//
//

import Foundation
import HandyJSON

class Enveloppe : HandyJSON {
    required init() { }

    private(set) public var type:String!
    private(set) public var payload:HandyJSON?
    
    init(withType type:String, payload:HandyJSON? = nil) {
        self.type = type
        self.payload = payload
    }
}
