import Foundation
import HandyJSON

/**
    Base class of all templates
 */
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
