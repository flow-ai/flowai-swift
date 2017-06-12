//
//  ListItem.swift
//  Pods
//
//  Created by Gijs van de Nieuwegiessen on 06/04/2017.
//
//

import Foundation
import HandyJSON

/**
    List item template
 */
public class ListItem : HandyJSON {
    
    /// True if this item should stand out
    private(set) public var highlight:Bool = false
    
    /// Title of the item
    private(set) public var title:String!
    
    /// Optional subtitle
    private(set) public var subtitle:String? = nil
    
    /// Optional image URL
    private(set) public var media:Media? = nil
    
    /// Optional set of buttons
    private(set) public var buttons:[Button]? = nil
    
    /// Optional action
    private(set) public var action:Action? = nil
    
    init(_ data: [String: Any]) throws {
    
        guard let title = data["title"] as? String else {
            throw Exception.Serialzation("listitem template has no title")
        }
        
        self.title = title
        
        if let subtitle = data["subtitle"] as? String {
            self.subtitle = subtitle
        }
        
        if let media = data["media"] as? [String:Any] {
            self.media = try Media(media)
        }
        
        if let highlight = data["highlight"] as? String {
            self.highlight = (highlight == "true") ? true : false
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
    
    public required init() { }
}
