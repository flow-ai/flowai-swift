import Foundation
import HandyJSON

/**
 Media element like an image or video
 */
public class Media : HandyJSON {
    
    /// Type of media
    private(set) public var type:String!
    
    /// URL of the media file
    private(set) public var url:URL!
    
    init(_ data: [String: Any]) throws {
        
        guard let type = data["type"] as? String else {
            throw Exception.Serialzation("media template has no title")
        }
        
        self.type = type
        
        guard let url = data["url"] as? String else {
            throw Exception.Serialzation("image template has no url")
        }
        
        self.url = URL(string: url)
        
    }
    
    public required init() {}
}
