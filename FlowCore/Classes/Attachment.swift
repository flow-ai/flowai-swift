import Foundation
import HandyJSON

/**
 * Attachment that is send with a message
 **/
public class Attachment : HandyJSON {
    
    // The type of Attachment
    public var type:String!
    
    // Payload of the attachment
    public var payload:AttachmentPayload!
    
    public init(_ payload:AttachmentPayload) {
        self.payload = payload
        if(payload is Event) {
            self.type = "EVENT"
        }
    }
    
    init(_ data: [String: Any]) throws {
        guard let type = data["type"] as? String else {
            throw Exception.Serialzation("Attachment has no type")
        }
        
        self.type = type
        
        guard let payload = data["payload"] as? [String: Any] else {
            throw Exception.Serialzation("Attachment must have a payload")
        }
        
        switch(type) {
        case "event":
            self.payload = try Event(payload)
            break
        default:
            break
        }
    }
    
    public required init() {}
}

/**
 * Payload of an attachment
 **/
public class AttachmentPayload : HandyJSON {
    public required init() {}
}
