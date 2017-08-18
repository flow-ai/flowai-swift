import Foundation

/**
 * Event trigger
 **/
public class Event : AttachmentPayload {
    
    public var name:String!
    
    public init(_ name:String) {
        self.name = name
    }
    
    init(_ data: [String: Any]) throws {
        guard let name = data["name"] as? String else {
            throw Exception.Serialzation("Event attachment must have a name")
        }
        
        self.name = name
    }
    
    public required init() {}
}
