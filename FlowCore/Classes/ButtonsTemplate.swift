import Foundation

/**
    A title with a list of buttons
 */
public class ButtonsTemplate : Template {
    
    /// Title of the set of buttons
    private(set) public var title:String!
    
    /// Collection of buttons
    private(set) public var buttons:[Button]!
    
    override init(_ data: [String: Any]) throws {
        
        try super.init(data)
        
        guard let title = data["title"] as? String else {
            throw Exception.Serialzation("card template has no title")
        }
        
        self.title = title
        
        guard let buttonsData = data["buttons"] as? [[String:Any]] else {
            throw Exception.Serialzation("buttons template has no buttons")
        }
        
        self.buttons = try buttonsData.map({ (buttonData:[String:Any] ) -> Button in
            return try Button(buttonData)
        })
    }
    
    public required init() {
        super.init()
    }
}
