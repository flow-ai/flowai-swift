//
//  card.swift
//  Pods
//
//  Created by Gijs van de Nieuwegiessen on 06/04/2017.
//
//

import Foundation

public class CardTemplate : Template {
    
    private(set) public var title:String!
    private(set) public var subtitle:String? = nil
    private(set) public var image:URL? = nil
    private(set) public var buttons:[Button]? = nil
    private(set) public var action:Action? = nil
    
    override init(_ data: [String: Any]) throws {
        
        try super.init(data)
        
        guard let title = data["title"] as? String else {
            throw Exception.Serialzation("card template has no title")
        }
        
        self.title = title
        
        if let subtitle = data["subtitle"] as? String {
            self.subtitle = subtitle
        }
        
        if let image = data["image"] as? String {
            self.image = URL(string: image)
        }
        
        if let buttonsData = data["buttons"] as? [[String:Any]] {
            self.buttons = try buttonsData.map({ (buttonData:[String:Any] ) -> Button in
                return try Button(buttonData)
            })
        }
        
        if let action = data["action"] as? [String:Any] {
            self.action = try Action(action)
        }
    }
    
    public required init() {
        super.init()
    }
}
