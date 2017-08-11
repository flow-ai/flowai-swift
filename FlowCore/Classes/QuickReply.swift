import Foundation
import HandyJSON

/**
    Button that can be attached to any template type
 */
public class QuickReply : HandyJSON {
    
    private(set) public var label: String!
    private(set) public var value: String!
    private(set) public var type: String!
    private(set) public var media: URL? = nil
    
    init(_ data: [String: Any]) throws {
        
        guard let label = data["label"] as? String else {
            throw Exception.Serialzation("button template has no label")
        }
        
        self.label = label
        
        guard let value = data["value"] as? String else {
            throw Exception.Serialzation("button template has no value")
        }
        
        self.value = value
        
        if let media = data["media"] as? String  {
            self.media = URL(string: media)
        }
        
        if let type = data["type"] as? String  {
            self.type = type
        } else {
            self.type = "text"
        }
    }
    
    public required init() {}
}
