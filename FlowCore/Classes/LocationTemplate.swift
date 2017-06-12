import Foundation

/**
    Location response template
 */
public class LocationTemplate : Template {
    
    /// Title of the location
    private(set) public var title:String?
    
    /// Latitude
    private(set) public var lat:Double!
    
    /// Longitude
    private(set) public var long:Double!
    
    /// Optional action
    private(set) public var action:Action? = nil
    
    override init(_ data: [String: Any]) throws {
        
        try super.init(data)
        
        guard let title = data["title"] as? String else {
            throw Exception.Serialzation("location template has no title")
        }
        
        self.title = title
        
        guard let lat = data["lat"] as? String else {
            throw Exception.Serialzation("location template has no latitude")
        }
        
        self.lat = Double(lat)
        
        guard let long = data["long"] as? String else {
            throw Exception.Serialzation("location template has no longitude")
        }
        
        self.long = Double(long)
        
        if let action = data["action"] as? [String:Any] {
            self.action = try Action(action)
        }
    }
    
    public required init() {
        super.init()
    }
}
