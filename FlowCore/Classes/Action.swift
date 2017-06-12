import Foundation
import HandyJSON

/**
    Action that can be assigned to certain templates
 */
public class Action : HandyJSON {
    
    /// Postback value or URL
    private(set) public var value: String!
    
    /// The kid of action; url, postback
    private(set) public var type: String!
    
    init(_ data: [String: Any]) throws {
        
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
