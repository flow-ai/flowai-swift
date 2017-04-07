//
//  buttons.swift
//  Pods
//
//  Created by Gijs van de Nieuwegiessen on 06/04/2017.
//
//

import Foundation
import HandyJSON

public class Button : HandyJSON {
    
    private(set) public var label: String!
    private(set) public var value: String!
    private(set) public var type: String!
    
    init(_ data: [String: Any]) throws {
        
        guard let label = data["label"] as? String else {
            throw Exception.Serialzation("button template has no label")
        }
        
        self.label = label
        
        guard let value = data["value"] as? String else {
            throw Exception.Serialzation("button template has no value")
        }
        
        self.value = value
        
        guard let type = data["type"] as? String else {
            throw Exception.Serialzation("button template has no type")
        }
        
        self.type = type
    }
    
    public required init() {}
}
