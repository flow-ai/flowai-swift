//
//  Activity.swift
//  FlowCore
//
//  Created by Gijs van de Nieuwegiessen on 09/04/2017.
//
//

import Foundation
import HandyJSON

public class Activity : HandyJSON {
    
    internal(set) public var threadId:String?
    public var originator:Originator!
    
    public required init() {}
}
