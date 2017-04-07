//
//  QuickReply.swift
//  Pods
//
//  Created by Gijs van de Nieuwegiessen on 06/04/2017.
//
//

import Foundation
import HandyJSON

public class QuickReply : HandyJSON {
    
    private(set) public var label: String!
    private(set) public var value: String!
    private(set) public var image: URL? = nil
    
    init(_ data: [String: Any]) throws {
        
        guard let label = data["label"] as? String else {
            throw Exception.Serialzation("button template has no label")
        }
        
        self.label = label
        
        guard let value = data["value"] as? String else {
            throw Exception.Serialzation("button template has no value")
        }
        
        self.value = value
        
        if let image = data["image"] as? String  {
            self.image = URL(string: image)
        }
    }
    
    public required init() {}
}
