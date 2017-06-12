import Foundation

/**
    Car response template
 */
public class CardTemplate : Template {
    
    /// Title of the card
    private(set) public var title:String!
    
    /// Optional descriptive subtitle
    private(set) public var subtitle:String? = nil
    
    /// Optional image URL
    private(set) public var media:URL? = nil
    
    /// Optional set of buttons
    private(set) public var buttons:[Button]? = nil
    
    /// Optional action for the entire card
    private(set) public var action:Action? = nil
    
    override init(_ data: [String: Any]) throws {
        
        try super.init(data)
        
        guard let title = data["title"] as? String else {
            throw Exception.Serialzation("card template has no title")
        }
        
        self.title = title
        
        if let subtitle = data["subtitle"] as? String {
            self.subtitle = subtitle
        }
        
        if let media = data["media"] as? String {
            self.media = URL(string: media)
        }
        
        if let buttonsData = data["buttons"] as? [[String:Any]] {
            self.buttons = try buttonsData.map({ (buttonData:[String:Any] ) -> Button in
                return try Button(buttonData)
            })
        }
        
        if let action = data["action"] as? [String:Any] {
            self.action = try Action(action)
        }
    }
    
    public required init() {
        super.init()
    }
}
