//
//  Template.swift
//  Pods
//
//  Created by Gijs van de Nieuwegiessen on 06/04/2017.
//
//

import Foundation
import HandyJSON

public class Template : HandyJSON {
    
    public var quickReplies:[QuickReply]? = nil
   
    init(_ data: [String: Any]) throws {
        if let quickRepliesData = data["quickReplies"] as? [[String:Any]] {
            self.quickReplies = try quickRepliesData.map({ (quickReplyData:[String:Any] ) -> QuickReply in
                return try QuickReply(quickReplyData)
            })
        }
    }
    
    
    public required init() {}
}
