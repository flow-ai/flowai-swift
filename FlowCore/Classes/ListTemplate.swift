//
//  ListTemplate.swift
//  Pods
//
//  Created by Gijs van de Nieuwegiessen on 06/04/2017.
//
//

import Foundation

public class ListTemplate : Template {
    
    private(set) public var items:[ListItem]!
    
    override init(_ data: [String: Any]) throws {
        
        try super.init(data)
        
        guard let itemsData = data["items"] as? [[String:Any]] else {
            throw Exception.Serialzation("items template has no items")
        }
        
        self.items = try itemsData.map({ (itemData:[String:Any] ) -> ListItem in
            return try ListItem(itemData)
        })
    }
    
    public required init() {
        super.init()
    }
}
