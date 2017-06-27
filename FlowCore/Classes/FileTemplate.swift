import Foundation

/**
    File response template
 */
public class FileTemplate : Template {
    
    /// Title of the file
    private(set) public var title:String!
    
    /// URL that points to the file
    private(set) public var url:URL!
    
    /// Optional action
    private(set) public var action:Action? = nil
    
    override init(_ data: [String: Any]) throws {
        
        try super.init(data)
        
        guard let title = data["title"] as? String else {
            throw Exception.Serialzation("file template has no title")
        }
        
        self.title = title
        
        guard let url = data["url"] as? String else {
            throw Exception.Serialzation("file template has no url")
        }
        
        self.url = URL(string: url)

        if let action = data["action"] as? [String:Any] {
            self.action = try Action(action)
        }
    }
    
    public required init() {
        super.init()
    }
}
