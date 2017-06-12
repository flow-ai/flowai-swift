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
    
    /// Label of the button
    private(set) public var label: String!
    
    /// Payload or URL
    private(set) public var value: String!
    
    /// Action of the button (url, postback, webview)
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
