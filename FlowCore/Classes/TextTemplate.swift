//
//  text.swift
//  Pods
//
//  Created by Gijs van de Nieuwegiessen on 06/04/2017.
//
//

import Foundation

public class TextTemplate : Template {
    
    private(set) public var text: String!
    
    override init(_ data: [String: Any]) throws {
        try super.init(data)
        guard let text = data["text"] as? String else {
            throw Exception.Serialzation("text template has no text")
        }
        
        self.text = text
    }

    public required init() {
        super.init()
    }
}
