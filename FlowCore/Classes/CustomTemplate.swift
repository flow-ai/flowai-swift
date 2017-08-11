import Foundation

/**
    Custom response template
    Use this to create custom UI elements like product listings, pages or widgets
 */
public class CustomTemplate : Template {
    
    /// Custom data
    private(set) public var data: [String: Any]!
    
    override init(_ data: [String: Any]) throws {
        try super.init(data)
        
        var filteredData = data
        filteredData.removeValue(forKey: "quickReplies")
        
        self.data = filteredData
    }

    public required init() {
        super.init()
    }
}


