//
//  CarouselTemplate.swift
//  Pods
//
//  Created by Gijs van de Nieuwegiessen on 06/04/2017.
//
//

import Foundation

public class CarouselTemplate : Template {
    
    private(set) public var cards:[CardTemplate]!
    
    override init(_ data: [String: Any]) throws {
        
        try super.init(data)
        
        guard let cardsData = data["cards"] as? [[String:Any]] else {
            throw Exception.Serialzation("cards template has no cards")
        }
        
        self.cards = try cardsData.map({ (cardData:[String:Any] ) -> CardTemplate in
            return try CardTemplate(cardData)
        })
    }
    
    public required init() {
        super.init()
    }
}
