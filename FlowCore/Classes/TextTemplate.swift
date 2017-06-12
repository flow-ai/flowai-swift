import Foundation

/**
    Simple text response template
 */
public class TextTemplate : Template {
    
    /// Spoken or written content
    private(set) public var text: String!
    
    override init(_ data: [String: Any]) throws {
        try super.init(data)
        guard let text = data["text"] as? String else {
            throw Exception.Serialzation("text template has no text")
        }
        
        self.text = text
    }

    public required init() {
        super.init()
    }
}
